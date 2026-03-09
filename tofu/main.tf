locals {
  talos_version        = "v1.12.4"
  control_plane_ip     = "192.168.30.100"
  default_proxmox_node = one(keys(var.proxmox_nodes))
}

module "talos" {
  source    = "./kubernetes/talos"
  providers = { proxmox = proxmox }

  # Talos image config
  image = {
    version           = local.talos_version
    schematic         = file("${path.module}/kubernetes/talos/image/schematic.yaml")
    proxmox_datastore = "isos" # where the image itself gets downloaded
  }

  # Cilium bootstrap (we'll wire the actual files later)
  cilium = {
    install = file("${path.module}/kubernetes/talos/inline-manifests/cilium-install.yaml")
    values  = file("${path.module}/../kubernetes/bootstrap/cilium/values.yaml")
  }

  # Talos/Kubernetes cluster-level config
  cluster = {
    name            = "talos"
    endpoint        = local.control_plane_ip # Control plane IP
    gateway         = var.lab_network.gateway
    talos_version   = local.talos_version
    proxmox_cluster = var.proxmox_cluster.cluster_name
  }

  # Talos Nodes
  nodes = {
    "ctrl-00" = {
      proxmox_node  = local.default_proxmox_node
      machine_type  = "controlplane"
      ip            = local.control_plane_ip
      mac_address   = "BC:24:11:2E:C8:00"
      vm_id         = 800
      cpu           = 4
      ram_dedicated = 6144
      disk          = 20
    }

    "work-00" = {
      proxmox_node  = local.default_proxmox_node
      machine_type  = "worker"
      ip            = "192.168.30.110"
      mac_address   = "BC:24:11:2E:08:00"
      vm_id         = 810
      cpu           = 4
      ram_dedicated = 11264
      disk          = 20
      igpu          = true
    }

    "work-01" = {
      proxmox_node  = local.default_proxmox_node
      machine_type  = "worker"
      ip            = "192.168.30.111"
      mac_address   = "BC:24:11:2E:08:01"
      vm_id         = 811
      cpu           = 4
      ram_dedicated = 11264
      disk          = 20
    }
  }

  # pass proxmox_nodes through so module can resolve them
  proxmox_nodes = var.proxmox_nodes
}

module "volumes" {
  depends_on = [module.talos]
  source     = "./kubernetes/bootstrap/volumes"

  providers = {
    restapi    = restapi
    kubernetes = kubernetes
  }

  proxmox_api = {
    endpoint     = var.proxmox_cluster.endpoint
    insecure     = var.proxmox_cluster.insecure
    cluster_name = var.proxmox_cluster.cluster_name
  }

  volumes = var.kubernetes_volumes
}

module "proxmox_csi_auth" {
  source = "./kubernetes/bootstrap/proxmox-csi-auth"

  cluster_name = var.proxmox_cluster.cluster_name
}

module "proxmox" {
  source    = "./proxmox"
  providers = { proxmox = proxmox }

  lab_network    = var.lab_network
  proxmox_nodes  = var.proxmox_nodes
  lxc_containers = var.lxc_containers
}