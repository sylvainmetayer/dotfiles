terraform {
  cloud {
    organization = "sylvainmetayer"
    workspaces {
      name = "homelab"
    }
  }
  required_providers {
    uptimerobot = {
      source = "louy/uptimerobot"
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
      source  = "go-gandi/gandi"
      version = "~> 2.0.0"
    }
  }
  required_version = ">= 0.15"
}

provider "uptimerobot" {}

provider "hcloud" {}

provider "healthchecksio" {}

provider "gandi" {}

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
