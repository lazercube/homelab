terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.89.0"
    }
    restapi = {
      source  = "Mastercard/restapi"
      version = ">= 2.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.32.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0.0"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_cluster.endpoint
  insecure = var.proxmox_cluster.insecure

  # api_token = var.proxmox_api_token
  username = var.proxmox_root_user
  password  = var.proxmox_root_password

  ssh {
    agent    = true
    username = var.proxmox_cluster.username
  }
}

provider "restapi" {
  uri                  = var.proxmox_cluster.endpoint
  insecure             = var.proxmox_cluster.insecure
  write_returns_object = true

  headers = {
    "Content-Type"  = "application/json"
    "Authorization" = "PVEAPIToken=${var.proxmox_api_token}"
  }
}

provider "kubernetes" {
  host                   = module.talos.kube_config.kubernetes_client_configuration.host
  client_certificate     = base64decode(module.talos.kube_config.kubernetes_client_configuration.client_certificate)
  client_key             = base64decode(module.talos.kube_config.kubernetes_client_configuration.client_key)
  cluster_ca_certificate = base64decode(module.talos.kube_config.kubernetes_client_configuration.ca_certificate)
}