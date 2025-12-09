proxmox_cluster = {
  endpoint     = "https://draco.lab.home:8006" # Any node in the Proxmox cluster will do.
  insecure     = true
  username     = "root"
  cluster_name = "homelab"
}

proxmox_nodes = {
  draco = {
    name         = "pve"
    datastore_id = "vmstore"
  }
}
