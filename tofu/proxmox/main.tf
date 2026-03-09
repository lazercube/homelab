# CT templates — one download resource per unique template URL across all containers.
locals {
  ct_templates = {
    for k, v in var.lxc_containers : k => v.template_url
  }
}

resource "proxmox_virtual_environment_download_file" "ct_template" {
  for_each = local.ct_templates

  node_name    = var.proxmox_nodes[var.lxc_containers[each.key].proxmox_node].name
  content_type = "vztmpl"
  datastore_id = "templates"
  url          = each.value
  file_name    = basename(each.value)
  overwrite    = false
}

resource "proxmox_virtual_environment_container" "this" {
  for_each = var.lxc_containers

  node_name    = var.proxmox_nodes[each.value.proxmox_node].name
  vm_id        = each.value.vm_id
  description  = each.value.description
  tags    = each.value.tags
  started = true
  unprivileged = each.value.unprivileged

  features {
    nesting = true
  }

  initialization {
    hostname = each.key

    ip_config {
      ipv4 {
        address = each.value.ip
        gateway = var.lab_network.gateway
      }
    }

    user_account {
      keys = each.value.ssh_public_keys
    }
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  disk {
    datastore_id = each.value.datastore_id
    size         = each.value.disk
  }

  dynamic "mount_point" {
    for_each = each.value.mount_points
    content {
      path   = mount_point.value.container_path
      volume = mount_point.value.host_path
    }
  }

  operating_system {
    template_file_id = proxmox_virtual_environment_download_file.ct_template[each.key].id
    type             = each.value.os_type
  }

  cpu {
    cores = each.value.cpu
  }

  memory {
    dedicated = each.value.ram
    swap      = each.value.swap
  }

  startup {
    order      = each.value.startup_order
    up_delay   = each.value.startup_up_delay
    down_delay = 0
  }
}

# Run NFS setup on any container tagged "nfs" after first provision.
# SSHes into the Proxmox node and uses pct exec — no SSH key needed in the container.
resource "null_resource" "nfs_setup" {
  for_each = {
    for k, v in var.lxc_containers : k => v
    if contains(v.tags, "nfs")
  }

  triggers = {
    container_id = proxmox_virtual_environment_container.this[each.key].id
  }

  depends_on = [proxmox_virtual_environment_container.this]

  connection {
    type    = "ssh"
    host    = var.proxmox_nodes[each.value.proxmox_node].ip
    user    = "root"
    agent   = true
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "pct exec ${each.value.vm_id} -- apk add --no-cache nfs-utils",
      "pct exec ${each.value.vm_id} -- sh -c 'echo \"/media ${var.lab_network.subnet}(rw,sync,no_subtree_check,no_root_squash)\" > /etc/exports'",
      "pct exec ${each.value.vm_id} -- sh -c 'printf MOUNTD_OPTS=\"-p 32767\"\\\\n > /etc/conf.d/nfs'",
      "pct exec ${each.value.vm_id} -- rc-update add nfs",
      "pct exec ${each.value.vm_id} -- rc-update add rpc.idmapd",
      "pct exec ${each.value.vm_id} -- rc-service rpc.idmapd start",
      "pct exec ${each.value.vm_id} -- rc-service nfs start",
    ]
  }
}
