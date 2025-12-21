#!/usr/bin/env bash
set -euo pipefail

NAME="${1:-}"

if [ -z "$NAME" ]; then
  echo "Usage: $0 <secret-name>"
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

TEMPLATE="${ROOT_DIR}/templates/secrets/${NAME}.yaml.tmpl"
PLAIN_OUT="${ROOT_DIR}/.tmp/${NAME}.secret.yaml"

# Map secret names to their destination paths in the managed infra
case "$NAME" in
  proxmox-csi)
    SEALED_OUT_DIR="${ROOT_DIR}/kubernetes/infra/storage/proxmox-csi"
    ;;
  cloudflare-cert-manager)
    SEALED_OUT_DIR="${ROOT_DIR}/kubernetes/infra/network/cert-manager"
    ;;
  cloudflare-dns)
    SEALED_OUT_DIR="${ROOT_DIR}/kubernetes/infra/network/dns"
    ;;
  *)
    # Default fallback for other secrets
    SEALED_OUT_DIR="${ROOT_DIR}/kubernetes/infra/${NAME}"
    ;;
esac

SEALED_OUT="${SEALED_OUT_DIR}/sealedsecret-${NAME}.yaml"
KUBECONFIG_FILE="${ROOT_DIR}/tofu/kubeconfig"

if [ ! -f "$KUBECONFIG_FILE" ]; then
  echo "ERROR: kubeconfig not found at ${KUBECONFIG_FILE}. Run 'task infra:configs' first."
  exit 1
fi

if [ ! -f "$TEMPLATE" ]; then
  echo "ERROR: template not found: ${TEMPLATE}"
  exit 1
fi

mkdir -p "${ROOT_DIR}/.tmp"
mkdir -p "${SEALED_OUT_DIR}"

case "$NAME" in
  proxmox-csi)
    # Uses Tofu outputs for token + endpoint + region
    export TOKEN_ID="$(cd "${ROOT_DIR}/tofu" && tofu output -raw proxmox_csi_auth_token_id)"
    export TOKEN_SECRET="$(cd "${ROOT_DIR}/tofu" && tofu output -raw proxmox_csi_auth_token_secret)"
    export REGION="$(cd "${ROOT_DIR}/tofu" && tofu output -raw proxmox_csi_auth_region)"
    export PROXMOX_API_URL="$(cd "${ROOT_DIR}/tofu" && tofu output -raw proxmox_endpoint)"
    ;;
  cloudflare-api-token)
    # Reads CLOUDFLARE_API_TOKEN from environment
    if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
      echo "ERROR: CLOUDFLARE_API_TOKEN environment variable not set."
      echo "Set it with: export CLOUDFLARE_API_TOKEN='your-token-here'"
      exit 1
    fi
    ;;
  cloudflare-api-token-external-dns)
    # Reads CLOUDFLARE_API_TOKEN from environment
    if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
      echo "ERROR: CLOUDFLARE_API_TOKEN environment variable not set."
      echo "Set it with: export CLOUDFLARE_API_TOKEN='your-token-here'"
      exit 1
    fi
    ;;
  *)
    echo "ERROR: don't know how to populate env vars for secret '${NAME}'."
    echo "Add a case for it in scripts/seal-secret.sh."
    exit 1
    ;;
esac

echo "Rendering template ${TEMPLATE} -> ${PLAIN_OUT}"
envsubst < "${TEMPLATE}" > "${PLAIN_OUT}"

echo "Sealing -> ${SEALED_OUT}"
if KUBECONFIG="${KUBECONFIG_FILE}" kubeseal --format=yaml \
    < "${PLAIN_OUT}" \
    > "${SEALED_OUT}"; then
  echo "SealedSecret written to ${SEALED_OUT}"
else
  echo "ERROR: kubeseal failed."
  rm -f "${PLAIN_OUT}"
  exit 1
fi

echo "Removing unsealed secret ${PLAIN_OUT}"
rm -f "${PLAIN_OUT}"

echo "Done. Commit ${SEALED_OUT} and ArgoCD will sync it."
