resource "proxmox_virtual_environment_vm" "this" {
  for_each = var.nodes

  # Which Proxmox hypervisor should host the VM
  node_name = var.proxmox_nodes[each.value.proxmox_node].name

  name        = each.key
  description = each.value.machine_type == "controlplane" ? "Talos Control Plane" : "Talos Worker"
  tags        = each.value.machine_type == "controlplane" ? ["k8s", "control-plane"] : ["k8s", "worker"]
  on_boot     = true
  vm_id       = each.value.vm_id

  machine       = "q35"
  scsi_hardware = "virtio-scsi-single"
  bios          = "seabios"

  agent {
    enabled = true
  }

  cpu {
    cores = each.value.cpu
    type  = "host"
  }

  memory {
    dedicated = each.value.ram_dedicated
  }

  network_device {
    bridge      = "vmbr0"                     # adjust if needed
    mac_address = each.value.mac_address
  }

  # Boot disk from Talos image downloaded in image.tf
  disk {
    # If node-level datastore_id is not set, fall back to proxmox_nodes default
    datastore_id = (
        each.value.datastore_id != "" ?
        each.value.datastore_id :
        var.proxmox_nodes[each.value.proxmox_node].datastore_id
    )

    interface    = "scsi0"
    iothread     = true
    cache        = "writethrough"
    discard      = "on"
    ssd          = true
    file_format  = "raw"
    size         = 20

    # IMPORTANT: this must be on a datastore accessible by that Proxmox node
    file_id = proxmox_virtual_environment_download_file.talos_image.id
  }

  boot_order = ["scsi0"]

  operating_system {
    type = "l26" # Linux 2.6–6.x
  }

  initialization {
    # Cloud-init disk / config storage
    datastore_id = (
        each.value.datastore_id != "" ?
        each.value.datastore_id :
        var.proxmox_nodes[each.value.proxmox_node].datastore_id
    )

    ip_config {
      ipv4 {
        address = "${each.value.ip}/24"   # adjust mask if needed
        gateway = var.cluster.gateway
      }
    }
  }

  # Optional Intel iGPU passthrough (requires Proxmox Resource Mapping "iGPU")
  dynamic "hostpci" {
    for_each = each.value.igpu ? [1] : []
    content {
      device  = "hostpci0"
      mapping = "iGPU"
      pcie    = true
      rombar  = true
      xvga    = false
    }
  }
}
