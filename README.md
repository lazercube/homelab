# Homelab

Homelab setup for provisioning a Talos-based Kubernetes cluster on Proxmox with OpenTofu.

## Prerequisites
- `tofu` - OpenTofu CLI
- `talosctl` - Talos CLI
- `kubectl` - Kubernetes CLI
- `kubeseal` - Sealed Secrets CLI

## Quick Start
1. Set values in `tofu/proxmox.auto.tfvars`.
2. Initialize and plan:
	```zsh
	cd tofu
	tofu init
	tofu validate
	tofu plan
	```
3. Apply:
	```zsh
	tofu apply
	```
4. Get kubeconfig:
	```zsh
	tofu output kube_config
	```