variable "proxmox_api" {
  type = object({
    endpoint     = string
    insecure     = bool
    cluster_name = string
  })
}

variable "proxmox_api_token" {
  description = "Proxmox API token. Set via TF_VAR_proxmox_api_token."
  type        = string
  sensitive   = true
}

variable "volumes" {
  type = map(object({
    node               = string
    size               = string
    storage            = optional(string, "local-zfs")
    storage_class_name = optional(string, "proxmox-csi")
    vmid               = optional(number, 9999)
    format             = optional(string, "raw")
  }))
}
