data "gandi_domain" "main" {
  name = "sylvain.dev"
}

# Import with "terraform import module.domains.gandi_livedns_record.website sylvain.dev/@/ALIAS"
resource "gandi_livedns_record" "website" {
  zone   = data.gandi_domain.main.name
  name   = "@"
  type   = "ALIAS"
  values = ["sylvain.netlify.app."]
  ttl    = var.default_ttl
}

resource "gandi_livedns_record" "www_website" {
  zone   = data.gandi_domain.main.name
  name   = "www"
  type   = "CNAME"
  values = ["sylvain.netlify.app."]
  ttl    = var.default_ttl
}

resource "gandi_livedns_record" "redirect" {
  zone   = data.gandi_domain.main.name
  name   = "r"
  type   = "CNAME"
  values = ["gracious-aryabhata-7fcbc1.netlify.app."]
  ttl    = var.default_ttl
}

