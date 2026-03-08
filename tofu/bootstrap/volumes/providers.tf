terraform {
  required_providers {
    restapi = {
      source  = "Mastercard/restapi"
      version = ">= 2.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.32.0"
    }
  }
}

provider "restapi" {
  uri                  = var.proxmox_api.endpoint
  insecure             = var.proxmox_api.insecure
  write_returns_object = true

  headers = {
    Authorization = "PVEAPIToken=${var.proxmox_api_token}"
    Content-Type  = "application/json"
  }
}

provider "kubernetes" {
  # path.module = tofu/bootstrap/volumes/ → ../.. = tofu/
  config_path = "${path.module}/../../kubeconfig"
}
