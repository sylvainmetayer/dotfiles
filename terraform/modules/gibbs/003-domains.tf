data "gandi_domain" "main" {
    name = "sylvain.dev"
}

resource "gandi_livedns_record" "nextcloud" {
  zone   = data.gandi_domain.main.name
  name   = "nuage"
  type   = "A"
  values = [hcloud_server.server.ipv4_address]
  ttl    = var.default_ttl
}

resource "gandi_livedns_record" "monica" {
  zone   = data.gandi_domain.main.name
  name   = "crm"
  type   = "A"
  values = [hcloud_server.server.ipv4_address]
  ttl    = var.default_ttl
}

resource "gandi_livedns_record" "gibbs" {
  zone   = data.gandi_domain.main.name
  name   = "gibbs"
  type   = "A"
  values = [hcloud_server.server.ipv4_address]
  ttl    = var.default_ttl
}

resource "gandi_livedns_record" "betisier" {
  zone   = data.gandi_domain.main.name
  name   = "betisier"
  type   = "A"
  values = [hcloud_server.server.ipv4_address]
  ttl    = var.default_ttl
}

resource "gandi_livedns_record" "rss" {
  zone   = data.gandi_domain.main.name
  name   = "rss"
  type   = "A"
  values = [hcloud_server.server.ipv4_address]
  ttl    = var.default_ttl
}
