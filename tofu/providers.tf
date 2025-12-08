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
    # kubernetes = {
    #   source  = "hashicorp/kubernetes"
    #   version = "3.0.0"
    # }
    # restapi = {
    #   source  = "Mastercard/restapi"
    #   version = "2.0.1"
    # }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_cluster.endpoint
  insecure = var.proxmox_cluster.insecure

  api_token = var.proxmox_cluster.api_token

  ssh {
    agent    = true
    username = var.proxmox_cluster.username
  }
}