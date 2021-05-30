terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.26.2"
    }
  }
}

resource "hcloud_ssh_key" "gop" {
  name       = "s.metayer@LGOP3007"
  public_key = file("../params/keys/gop.pub")
}

resource "hcloud_ssh_key" "dell" {
  name       = "ocyhc@dell"
  public_key = file("../params/keys/dell.pub")
}

resource "hcloud_firewall" "firewall" {
  name = "basic-filters"
  rule {
    direction = "in"
    port      = 80
    protocol  = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = 443
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = 22
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_server" "server" {
  name        = "gibbs"
  image       = "debian-10"
  server_type = "cx21"
  location    = "nbg1"
  datacenter  = "nbg1-dc3"
  keep_disk   = true
  # FIXME Uncomment when we need to reforce creation, not for now.
  # ssh_keys     = [hcloud_ssh_key.gop.id, hcloud_ssh_key.dell.id]
  firewall_ids = [hcloud_firewall.firewall.id]
  depends_on = [
    hcloud_firewall.firewall,
    hcloud_ssh_key.gop,
    hcloud_ssh_key.dell
  ]
}
