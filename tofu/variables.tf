# Cluster-wide Proxmox config
variable "proxmox_cluster" {
  description = "Connection details for the Proxmox cluster"
  type = object({
    endpoint     = string # e.g. "https://pve.home:8006"
    insecure     = bool   # true for self-signed TLS
    username     = string # SSH user, e.g. "root"
    cluster_name = string # Proxmox cluster name (e.g. 'pve' or 'homelab')
  })
}

# Proxmox API token for authentication
variable "proxmox_api_token" {
  description = "Proxmox API token (read from env / .envrc)"
  type        = string # e.g. "user@realm!name=secret"
  sensitive   = true
}

# Individual Proxmox nodes
variable "proxmox_nodes" {
  description = "Individual Proxmox nodes in the cluster"
  type = map(object({
    name         = string # node name in Proxmox UI, e.g. "pve" or "pve-01"
    datastore_id = string # default datastore for VM disks on this node, e.g. "vmstore"
  }))
}

variable "kubernetes_volumes" {
  description = "Named persistent volumes to pre-provision on Proxmox and register as Kubernetes PVs"
  type = map(object({
    node               = string
    size               = string
    storage            = optional(string, "local-zfs")
    storage_class_name = optional(string, "proxmox-csi")
    vmid               = optional(number, 9999)
    format             = optional(string, "raw")
  }))
  default = {}
}

variable "lab_network" {
  description = "Shared network settings for the lab subnet"
  type = object({
    gateway = string # IPv4 gateway, e.g. "192.168.30.1"
  })
}

variable "lxc_containers" {
  description = "LXC containers to provision on Proxmox"
  type = map(object({
    proxmox_node    = string
    vm_id           = number
    description     = optional(string, "")
    tags            = optional(list(string), [])
    unprivileged    = optional(bool, true)
    ip              = string       # CIDR, e.g. "192.168.30.120/24"
    ssh_public_keys = list(string)
    datastore_id    = optional(string, "vmstore")
    disk            = optional(number, 8)  # GB
    cpu             = optional(number, 2)
    ram             = optional(number, 512)
    swap            = optional(number, 512)
    os_type         = optional(string, "debian")
    template_url    = string
    startup_order      = optional(number, 1)
    startup_up_delay   = optional(number, 30)
    mount_points = optional(list(object({
      host_path      = string
      container_path = string
    })), [])
  }))
  default = {}
}
