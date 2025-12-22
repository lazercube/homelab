# Environment Variables

Create a `.envrc` file in the root of the repository to set environment variables needed for various scripts and deployments. Below are the variables you may need to set:

```bash
export TF_VAR_proxmox_api_token=""
export CLOUDFLARE_API_TOKEN=""
export GRAFANA_ADMIN_PASSWORD=""
export TALOSCONFIG=$(pwd)/tofu/talosconfig
export KUBECONFIG=$(pwd)/tofu/kubeconfig
```