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
