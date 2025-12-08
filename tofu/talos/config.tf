# Shared Talos secrets
resource "talos_machine_secrets" "this" {
  talos_version = var.cluster.talos_version
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster.name
  client_configuration = talos_machine_secrets.this.client_configuration

  nodes     = [for _, n in var.nodes : n.ip]
  endpoints = [for _, n in var.nodes : n.ip if n.machine_type == "controlplane"]
}

# Per-node machine config
data "talos_machine_configuration" "this" {
  for_each = var.nodes

  cluster_name     = var.cluster.name
  cluster_endpoint = var.cluster.endpoint
  talos_version    = var.cluster.talos_version
  machine_type     = each.value.machine_type
  machine_secrets  = talos_machine_secrets.this.machine_secrets

  config_patches = each.value.machine_type == "controlplane" ? [
    templatefile("${path.module}/machine-config/control-plane.yaml.tftpl", {
      hostname       = each.key
      node_name      = var.proxmox_nodes[each.value.proxmox_node].name
      cluster_name   = var.cluster.proxmox_cluster
      cilium_values  = var.cilium.values
      cilium_install = var.cilium.install
    })
  ] : [
    templatefile("${path.module}/machine-config/worker.yaml.tftpl", {
      hostname     = each.key
      node_name    = var.proxmox_nodes[each.value.proxmox_node].name
      cluster_name = var.cluster.proxmox_cluster
    })
  ]
}

# Apply Talos configuration
resource "talos_machine_configuration_apply" "this" {
  depends_on = [proxmox_virtual_environment_vm.this]

  for_each = var.nodes

  node                        = each.value.ip
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.this[each.key].machine_configuration

  # Re-apply config whenever the VM is recreated/changed
  lifecycle {
    replace_triggered_by = [proxmox_virtual_environment_vm.this[each.key]]
  }
}

# Bootstrap Talos
resource "talos_machine_bootstrap" "this" {
  # first control-plane node
  node                 = [for _, n in var.nodes : n.ip if n.machine_type == "controlplane"][0]
  endpoint             = var.cluster.endpoint
  client_configuration = talos_machine_secrets.this.client_configuration
}

# Cluster health & kcfg
data "talos_cluster_health" "this" {
  depends_on = [
    talos_machine_configuration_apply.this,
    talos_machine_bootstrap.this
  ]

  client_configuration = data.talos_client_configuration.this.client_configuration
  control_plane_nodes  = [for _, n in var.nodes : n.ip if n.machine_type == "controlplane"]
  worker_nodes         = [for _, n in var.nodes : n.ip if n.machine_type == "worker"]
  endpoints            = data.talos_client_configuration.this.endpoints

  timeouts = {
    read = "10m"
  }
}

data "talos_cluster_kubeconfig" "this" {
  depends_on = [
    talos_machine_bootstrap.this,
    data.talos_cluster_health.this
  ]

  node                 = [for _, n in var.nodes : n.ip if n.machine_type == "controlplane"][0]
  endpoint             = var.cluster.endpoint
  client_configuration = talos_machine_secrets.this.client_configuration

  timeouts = {
    read = "1m"
  }
}
