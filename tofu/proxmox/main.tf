# Hardware mappings for the Proxmox Virtual Environment provider.
resource "proxmox_virtual_environment_hardware_mapping_pci" "igpu" {
  name    = "iGPU"
  comment = "AMD Radeon 780M (Phoenix3) - R7 PRO 8845HS integrated GPU"

  map = [
    {
      comment      = "VGA controller - required for VAAPI transcoding"
      id           = "1002:1900"
      subsystem_id = "1002:0124"
      node         = "draco"
      path         = "0000:01:00.0"
      iommu_group  = 26
    },
  ]

  mediated_devices = false
}
