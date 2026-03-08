variable "volume" {
  description = "Proxmox volume configuration"
  type = object({
    name    = string
    node    = string
    storage = string
    size    = string
    vmid    = optional(number, 9999)
    format  = optional(string, "raw")
  })
}
