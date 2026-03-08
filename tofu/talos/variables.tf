variable "image" {
  description = "Talos image configuration"
  type = object({
    factory_url       = optional(string, "https://factory.talos.dev")
    schematic         = string
    version           = string
    update_schematic  = optional(string)
    update_version    = optional(string)
    arch              = optional(string, "amd64")
    platform          = optional(string, "nocloud")
    proxmox_datastore = optional(string, "local")
  })
}

variable "cluster" {
  description = "Talos cluster configuration"
  type = object({
    name            = string
    endpoint        = string
    gateway         = string
    talos_version   = string
    proxmox_cluster = string
  })
}

# Reuse the same proxmox_nodes shape inside the module
variable "proxmox_nodes" {
  description = "Proxmox nodes used by Talos VMs"
  type = map(object({
    name         = string
    datastore_id = string
  }))
}

variable "nodes" {
  description = "Configuration for Talos nodes"
  type = map(object({
    proxmox_node = string         # key into var.proxmox_nodes
    machine_type = string         # "controlplane" or "worker"
    datastore_id = optional(string, "")   # override default datastore if needed
    ip           = string
    mac_address  = string
    vm_id        = number
    cpu          = number
    ram_dedicated = number
    update       = optional(bool, false)
    igpu         = optional(bool, false)
  }))
}

variable "cilium" {
  description = "Cilium configuration"
  type = object({
    values  = string
    install = string
  })
}
