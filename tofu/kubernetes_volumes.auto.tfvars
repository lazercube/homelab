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
}
