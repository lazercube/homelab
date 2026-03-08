locals {
  filename = "vm-${var.volume.vmid}-${var.volume.name}"
}

resource "restapi_object" "proxmox-volume" {
  path         = "/api2/json/nodes/${var.volume.node}/storage/${var.volume.storage}/content"
  id_attribute = "data"

  data = jsonencode({
    vmid     = var.volume.vmid
    filename = local.filename
    size     = var.volume.size
    format   = var.volume.format
  })

  # Proxmox returns size in bytes (not e.g. "1G"), which would cause perpetual drift.
  # ignore_all_server_changes suppresses this without ignoring the data we send.
  ignore_all_server_changes = true

  # update_data must be a valid (even if no-op) body for the PUT request.
  update_data = jsonencode({
    node = var.volume.node
  })

  lifecycle {
    prevent_destroy = false
  }
}

output "node" {
  value = var.volume.node
}

output "storage" {
  value = var.volume.storage
}

output "filename" {
  value = local.filename
}
