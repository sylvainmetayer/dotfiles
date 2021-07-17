terraform {
  required_providers {
    gandi = {
      source  = "psychopenguin/gandi"
      version = "2.0.0-rc3"
    }
  }
}

data "gandi_domain" "main" {
  name = "sylvain.dev"
}

resource "gandi_livedns_record" "simplelogin_dkim" {
  zone   = data.gandi_domain.main.name
  name   = "dkim._domainkey"
  type   = "CNAME"
  values = ["dkim._domainkey.simplelogin.co."]
  ttl    = var.default_ttl
}

resource "gandi_livedns_record" "simplelogin_dmarc" {
  zone   = data.gandi_domain.main.name
  name   = "_dmarc"
  type   = "TXT"
  values = ["\"v=DMARC1; p=quarantine; pct=100; adkim=s; aspf=s\""]
  ttl    = var.default_ttl
}

resource "gandi_livedns_record" "simplelogin_spf" {
  zone   = data.gandi_domain.main.name
  name   = "@"
  type   = "TXT"
  values = ["\"v=spf1 include:simplelogin.co -all\""]
  ttl    = var.default_ttl
}
