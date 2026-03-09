variable "proxmox_nodes" {
  description = "Individual Proxmox nodes in the cluster"
  type = map(object({
    name         = string
    datastore_id = string
    gateway      = string
  }))
}

variable "lxc_containers" {
  description = "LXC containers to provision on Proxmox"
  type = map(object({
    proxmox_node    = string
    vm_id           = number
    description     = optional(string, "")
    tags            = optional(list(string), [])
    unprivileged    = optional(bool, true)
    ip              = string # CIDR, e.g. "192.168.30.120/24"
    ssh_public_keys = list(string)
    datastore_id    = optional(string, "vmstore")
    disk            = optional(number, 8) # GB
    cpu             = optional(number, 2)
    ram             = optional(number, 512)
    swap            = optional(number, 512)
    os_type         = optional(string, "debian")
    template_url    = string
    startup_order    = optional(number, 1)
    startup_up_delay = optional(number, 30)
    mount_points = optional(list(object({
      host_path      = string
      container_path = string
    })), [])
  }))
  default = {}
}
