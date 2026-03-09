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
