terraform {
  backend "s3" {
    bucket                      = "tf-backend-state"
    key                         = "terraform.tfstate"
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
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.26.2"
    }
    healthchecksio = {
      source  = "kristofferahl/healthchecksio"
      version = "1.9.0"
    }
    gandi = {
      source  = "psychopenguin/gandi"
      version = "2.0.0-rc3"
    }
  }
  required_version = ">= 0.15"
}

provider "uptimerobot" {}

provider "hcloud" {}

provider "healthchecksio" {}

provider "gandi" {}

# Monitoring with UpTimeRobot
module "monitoring" {
  source               = "./modules/monitoring"
  status_page_password = var.status_page_password
  backup_sftp_url      = var.backup_sftp_url
}

# VPS on Hetzner
module "gibbs" {
  source = "./modules/gibbs"
}

# Gandi DNS zones
module "domains" {
  source = "./modules/domains"
}

module "sl_main" {
  source = "./modules/simplelogin"
}
