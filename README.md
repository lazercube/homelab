# Homelab

My personal homelab: a local Proxmox cluster running Talos-based Kubernetes, managed with OpenTofu and Argo CD.

## Setup
1. Configure Proxmox and cluster values in `tofu/proxmox.auto.tfvars`.
2. Verify local tooling and environment:
	 ```zsh
	 task env:check
	 ```

## Bootstrap
Provision infra, write configs, install controllers, and setup kubernetes:
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
	task secrets:seal NAME=proxmox-csi
	task secrets:seal-all
	```

## Learn more
- See `wiki/` for architecture, operations, and troubleshooting.