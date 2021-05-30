terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.26.2"
    }
    healthchecksio = {
      source  = "kristofferahl/healthchecksio"
      version = "1.9.0"
    }
  }
}
