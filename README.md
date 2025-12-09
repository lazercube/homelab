# Homelab

Talos-based Kubernetes on Proxmox, provisioned with OpenTofu and bootstrapped with Argo CD.

## Requirements
- `direnv` with `.envrc` setting `TF_VAR_proxmox_api_token`
- CLIs: `tofu`, `kubectl`, `kubeseal`

## Setup
1. Configure Proxmox and cluster values in `tofu/proxmox.auto.tfvars`.
2. Verify local tooling and environment:
	 ```zsh
	 task env:check
	 ```

## Bootstrap
Provision infra, write configs, install controllers, and Argo CD:
```zsh
task cluster:bootstrap
```

## Day‑to‑day
- List available tasks:
	```zsh
	task
	```
- Plan/apply infra changes:
	```zsh
	task infra:plan
	task infra:apply
	```
- Export kubeconfig and talosconfig:
	```zsh
	task infra:configs
	```
- Seal secrets:
	```zsh
	task secrets:seal NAME=csi-secret
	task secrets:seal-all
	```

## Learn more
- See `wiki/` for architecture, operations, and troubleshooting.