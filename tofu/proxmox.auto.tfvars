# Configure the Proxmox cluster connection details
proxmox_cluster = {
  endpoint     = "https://draco.lab.home:8006" # Any node in the Proxmox cluster will do.
  insecure     = true
  username     = "root"
  cluster_name = "homelab"
}

# Define each Proxmox node in the cluster you plan to use
proxmox_nodes = {
  draco = {
    name         = "draco"
    datastore_id = "vmstore"
  }
}

# Define LXC containers to provision on Proxmox
lxc_containers = {
  "nfs-00" = {
    proxmox_node = "draco"
    vm_id        = 900
    description  = "NFS server — exports bulkzfs/media"
    tags         = ["nfs", "media"]
    unprivileged = false # privileged required for NFS kernel server (nfsd)
    ip           = "192.168.30.120/24"
    ssh_public_keys = [
      # "ssh-ed25519 AAAA... user@host",
    ]
    datastore_id = "vmstore"
    disk         = 8
    cpu          = 2
    ram          = 512
    swap         = 512
    os_type      = "alpine"
    template_url = "http://download.proxmox.com/images/system/alpine-3.21-default_20241217_amd64.tar.xz"
    startup_order    = 1
    startup_up_delay = 30
    mount_points = [
      {
        host_path      = "/bulkzfs/media"
        container_path = "/media"
      },
    ]
  }
}