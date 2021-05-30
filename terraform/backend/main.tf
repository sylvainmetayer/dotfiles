# This file should be needed to run only once.
# State is stored on personal kDrive and symlinked to params/setup-backend.tfstate but not really useful once bucket is created
terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.15"
  backend "local" {
    path = "../../params/setup-backend.tfstate"
  }
}

variable "region" {
  default = "fr-par"
  type    = string
}

variable "backend_bucket" {
  type = string
}

variable "scw_zone" {
  type = string
}

variable "scw_region" {
  type = string
}

provider "scaleway" {
  zone   = var.scw_zone
  region = var.scw_region
}

resource "scaleway_object_bucket" "state" {
  name   = var.backend_bucket
  region = var.scw_region
  acl    = "private"
}
