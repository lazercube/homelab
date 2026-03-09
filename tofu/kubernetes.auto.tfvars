kubernetes_volumes = {
  "pv-grafana" = {
    node               = "draco"
    size               = "5Gi"
    storage            = "vmstore"
    storage_class_name = "proxmox-fast"
  }
  "pv-prometheus" = {
    node               = "draco"
    size               = "25Gi"
    storage            = "bulkzfs"
    storage_class_name = "proxmox-bulk"
  }
  "pv-jellyfin" = {
    node               = "draco"
    size               = "20Gi"
    storage            = "vmstore"
    storage_class_name = "proxmox-fast"
  }
  "pv-jellyseerr" = {
    node               = "draco"
    size               = "5Gi"
    storage            = "vmstore"
    storage_class_name = "proxmox-fast"
  }
  "pv-radarr" = {
    node               = "draco"
    size               = "5Gi"
    storage            = "vmstore"
    storage_class_name = "proxmox-fast"
  }
  "pv-sonarr" = {
    node               = "draco"
    size               = "5Gi"
    storage            = "vmstore"
    storage_class_name = "proxmox-fast"
  }
  "pv-qbittorrent" = {
    node               = "draco"
    size               = "5Gi"
    storage            = "vmstore"
    storage_class_name = "proxmox-fast"
  }
  "pv-qui" = {
    node               = "draco"
    size               = "1Gi"
    storage            = "vmstore"
    storage_class_name = "proxmox-fast"
  }
  "pv-filebrowser" = {
    node               = "draco"
    size               = "1Gi"
    storage            = "vmstore"
    storage_class_name = "proxmox-fast"
  }
}
