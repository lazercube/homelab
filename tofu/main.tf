module "talos" {
  source    = "./talos"
  providers = { proxmox = proxmox }

  # Talos image config
  image = {
    version           = "v1.11.5"
    schematic         = file("${path.module}/talos/image/schematic.yaml")
    factory_url       = "https://factory.talos.dev"
    arch              = "amd64"
    platform          = "nocloud"
    proxmox_datastore = "isos" # where the image itself gets downloaded
  }

  # Cilium bootstrap (we’ll wire the actual files later)
  cilium = {
    install = file("${path.module}/talos/inline-manifests/cilium-install.yaml")
    values  = file("${path.module}/../kubernetes/bootstrap/cilium/values.yaml")
  }

  # Talos/Kubernetes cluster-level config
  cluster = {
    name            = "talos"
    endpoint        = "192.168.30.100" # API endpoint IP (ctrl-00)
    gateway         = "192.168.30.1"   # your LAN gateway
    talos_version   = "v1.7"
    proxmox_cluster = var.proxmox_cluster.cluster_name
  }

  # Talos Nodes
  nodes = {
    "ctrl-00" = {
      proxmox_node  = "draco" # maps to proxmox_nodes key
      machine_type  = "controlplane"
      ip            = "192.168.30.100" # static IP for this node
      mac_address   = "BC:24:11:2E:C8:00"
      vm_id         = 800
      cpu           = 4
      ram_dedicated = 4096
      # datastore_id optional (we default from proxmox_nodes)
      # update/igpu use defaults
    }
  }

  # pass proxmox_nodes through so module can resolve them
  proxmox_nodes = var.proxmox_nodes
}

module "proxmox_csi_auth" {
  source = "./bootstrap/proxmox-csi-auth"

  cluster_name = var.proxmox_cluster.cluster_name
}