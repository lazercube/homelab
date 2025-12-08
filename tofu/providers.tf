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

# Proxmox provider – OpenTofu will talk to your PVE API + SSH
provider "proxmox" {
  endpoint = var.proxmox.endpoint   # e.g. "https://pve.home:8006"
  insecure = var.proxmox.insecure   # true if you’re using self-signed cert

  api_token = var.proxmox.api_token # PVEAPIToken ID=secret

  ssh {
    agent   = true
    # This must be a user that can run qm/qm importdisk on the Proxmox host
    username = var.proxmox.username # e.g. "root"
  }
}