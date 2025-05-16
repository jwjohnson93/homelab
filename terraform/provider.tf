terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc9"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.0.0"
    }
  }
}

provider "vault" {
  address = "http://127.0.0.1:8200"
  token   = var.vault_token
}

data "vault_kv_secret_v2" "proxmox" {
  mount = "secret"
  name  = "proxmox"
}

provider "proxmox" {
  pm_api_url          = data.vault_kv_secret_v2.proxmox.data["api_url"]
  pm_api_token_id     = data.vault_kv_secret_v2.proxmox.data["api_token_id"]
  pm_api_token_secret = data.vault_kv_secret_v2.proxmox.data["api_token_secret"]
  pm_tls_insecure     = true
}

variable "vault_token" {
  type      = string
  sensitive = true
}

