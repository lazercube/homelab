output "proxmox_endpoint" {
  value = var.proxmox_cluster.endpoint
}

output "talosconfig" {
  value     = module.talos.client_configuration.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = module.talos.kube_config.kubeconfig_raw
  sensitive = true
}

# Proxmox CSI auth outputs
output "proxmox_csi_auth_token_id" {
  value     = module.proxmox_csi_auth.token_id
  sensitive = true
}

output "proxmox_csi_auth_token_secret" {
  value     = module.proxmox_csi_auth.token_secret
  sensitive = true
}

output "proxmox_csi_auth_region" {
  value = module.proxmox_csi_auth.region
}