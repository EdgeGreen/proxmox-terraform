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
    aws = {
      source  = "hashicorp/aws"
      version = "4.52.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
  required_version = ">= 1.1.0"

  # https://registry.terraform.io/providers/FlexibleEngineCloud/flexibleengine/latest/docs/guides/remote-state-backend
  #--------------------------------------------------------------------------------------------------------------------
  backend "s3" {
    bucket         = "edge-global-terraform-state-bucket"
    key            = "tf-backend/proxmox/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "edge-global-terraform-state-table"
    encrypt        = true
  }
}

provider "proxmox" {
  pm_api_url          = "https://${var.px_provider.pm_api_url}:8006/api2/json"
  pm_api_token_id     = var.px_provider.pm_api_token_id
  pm_api_token_secret = var.px_provider.pm_api_token_secret
  pm_tls_insecure     = true
  pm_debug            = true
  pm_log_enable       = true
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      "organization" = "edge-green",
      "Workspaces"   = "proxvox",
      "Team"         = "DevOps",
      "DeployedBy"   = "Terraform",
      "OwnerEmail"   = "devops@example.com"
    }
  }
}
