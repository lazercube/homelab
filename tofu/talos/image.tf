locals {
  factory_url = var.image.factory_url
  platform    = var.image.platform
  arch        = var.image.arch
  version     = var.image.version
  schematic   = var.image.schematic

  schematic_id = jsondecode(data.http.schematic_id.response_body)["id"]
}

data "http" "schematic_id" {
  url          = "${local.factory_url}/schematics"
  method       = "POST"
  request_body = local.schematic
}

resource "proxmox_virtual_environment_download_file" "talos_image" {
  node_name    = one(values(var.proxmox_nodes)).name  # just pick any node; image is cluster-visible
  content_type = "iso"
  datastore_id = var.image.proxmox_datastore

  decompression_algorithm = "gz"
  overwrite               = false

  url = "${local.factory_url}/image/${local.schematic_id}/${local.version}/${local.platform}-${local.arch}.raw.gz"

  file_name = "talos-${local.schematic_id}-${local.version}-${local.platform}-${local.arch}.img"
}
