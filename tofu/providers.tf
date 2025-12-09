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
  }
}

provider "proxmox" {
  endpoint = var.proxmox_cluster.endpoint
  insecure = var.proxmox_cluster.insecure

  api_token = var.proxmox_api_token

  ssh {
    agent    = true
    username = var.proxmox_cluster.username
  }
}