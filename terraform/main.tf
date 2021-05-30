terraform {
  backend "s3" {
    bucket                      = "tf-backend-state"
    key                         = "state.tfstate"
    region                      = "fr-par"
    endpoint                    = "https://s3.fr-par.scw.cloud"
    skip_credentials_validation = true
    skip_region_validation      = true
  }
  required_providers {
    uptimerobot = {
      source = "louy/uptimerobot"
    }
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.15"
}

provider "uptimerobot" {}

module "monitoring" {
  source          = "./modules/monitoring"
  backup_sftp_url = var.backup_sftp_url
}
