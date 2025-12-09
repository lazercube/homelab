locals {
  token_parts = split("=", proxmox_virtual_environment_user_token.kubernetes_csi_token.value)
}

output "token_id" {
  # e.g. "kubernetes-csi@pve!csi"
  value     = proxmox_virtual_environment_user_token.kubernetes_csi_token.id
  sensitive = true
}

output "token_secret" {
  # value is "<user@realm!name>=<secret>", we want just the secret
  value     = local.token_parts[length(local.token_parts) - 1]
  sensitive = true
}

output "region" {
  value = var.cluster_name
}
