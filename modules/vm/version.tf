terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.3.0"
    }
  }
  required_version = ">= 0.13"
}
provider "proxmox" {
  pm_api_url          = "https://192.168.33.9:8006/api2/json"
  pm_api_token_id     = "root@pam!terraform-prox"
  pm_api_token_secret = "e995847d-51e1-4540-87bb-07462f4e819b"
  pm_tls_insecure     = true
  pm_debug            = true
}
