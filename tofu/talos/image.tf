# Register the schematic with the image factory and get back a stable ID.
# This is the single source of truth — upgrades reuse the same schematic.
resource "talos_image_factory_schematic" "this" {
  schematic = var.image.schematic
}

# URLs for the initial install image (downloaded to Proxmox)
data "talos_image_factory_urls" "install" {
  talos_version = var.image.version
  schematic_id  = talos_image_factory_schematic.this.id
  platform      = var.image.platform
  architecture  = var.image.arch
}

# URLs for the upgrade image — same schematic, optionally a newer Talos version
data "talos_image_factory_urls" "update" {
  talos_version = coalesce(var.image.update_version, var.image.version)
  schematic_id  = talos_image_factory_schematic.this.id
  platform      = var.image.platform
  architecture  = var.image.arch
}

# Download the install image to Proxmox (if it’s not already there)
resource "proxmox_virtual_environment_download_file" "talos_image" {
  node_name    = one(values(var.proxmox_nodes)).name
  content_type = "iso"
  datastore_id = var.image.proxmox_datastore

  decompression_algorithm = "gz"
  overwrite               = false

  url       = data.talos_image_factory_urls.install.urls.disk_image
  file_name = "talos-${talos_image_factory_schematic.this.id}-${var.image.version}-${var.image.platform}-${var.image.arch}.img"
}
