output "talosconfig" {
  value     = module.talos.client_configuration.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = module.talos.kube_config.kubeconfig_raw
  sensitive = true
}
