# Homelab

Talos-based Kubernetes cluster on Proxmox, managed with OpenTofu and Argo CD.

## Prerequisites
- `direnv` enabled with `.envrc` exporting `TF_VAR_proxmox_api_token`
- `tofu`, `kubectl`, `kubeseal` installed

## Quick Start
1. Configure Proxmox + cluster settings in `tofu/proxmox.auto.tfvars`.
2. Bootstrap the cluster:
	 ```zsh
	 task cluster:bootstrap
	 ```
	 This runs init, validate, apply, writes kube/talos configs, and installs Argo CD.
