variable "proxmox_cluster" {
  description = "Proxmox cluster connection details"
  type = object({
    endpoint     = string
    insecure     = bool
    username     = string
    cluster_name = string
  })
}

variable "proxmox_api_token" {
  description = "Proxmox API token for authentication"
  type        = string
  sensitive   = true
}
