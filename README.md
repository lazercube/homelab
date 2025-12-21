### [Network](192.168.1.1) │ [Proxmox](https://192.168.30.10:8006) | [ArgoCD](https://argocd.localcloud.network)

# Homelab

My personal homelab: A local Proxmox cluster running Talos-based Kubernetes, managed with OpenTofu and Argo CD.

> [!NOTE]
> This is a showcase of my homelab setup, not a step-by-step guide. Configuration details are specific to my environment and may require adaptation for your use case.

## Setup
1. Configure Proxmox and cluster values in `tofu/proxmox.auto.tfvars`.
2. Verify local tooling and environment:
	 ```zsh
	 task env:check
	 ```

## Bootstrap
Provision infra, write configs, install controllers, and setup kubernetes:
```zsh
task bootstrap:init
task boostrap:apply
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

## Acknowledgements

This setup is based on ideas and configurations from:
- [Talos cluster on Proxmox with Terraform](https://olav.ninja/talos-cluster-on-proxmox-with-terraform) by Olav
- [Talos on Proxmox with OpenTofu](https://blog.stonegarden.dev/articles/2024/08/talos-proxmox-tofu) by Stonegarden
