locals {
  factory_url = var.image.factory_url
  platform    = var.image.platform
  arch        = var.image.arch
  version     = var.image.version
  schematic   = var.image.schematic

  schematic_id = jsondecode(data.http.schematic_id.response_body)["id"]

  # Upgrade image — falls back to current schematic/version if overrides not set
  upgrade_schematic_id = var.image.update_schematic != null ? jsondecode(data.http.update_schematic_id[0].response_body)["id"] : local.schematic_id
  upgrade_version      = coalesce(var.image.update_version, local.version)
}

data "http" "schematic_id" {
  url          = "${local.factory_url}/schematics"
  method       = "POST"
  request_body = local.schematic
}

data "http" "update_schematic_id" {
  count        = var.image.update_schematic != null ? 1 : 0
  url          = "${local.factory_url}/schematics"
  method       = "POST"
  request_body = var.image.update_schematic
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
