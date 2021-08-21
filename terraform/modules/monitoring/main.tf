terraform {
  required_providers {
    uptimerobot = {
      source  = "louy/uptimerobot"
      version = "0.5.1"
    }
  }
}

data "uptimerobot_account" "account" {}

data "uptimerobot_alert_contact" "default" {
  friendly_name = data.uptimerobot_account.account.email
}

resource "uptimerobot_monitor" "backup_sftp" {
  friendly_name = "SFTP Hetzner - backup"
  url           = var.backup_sftp_url
  interval      = 300
  type          = "port"
  sub_type      = "custom"
  port          = 23

  alert_contact {
    id = data.uptimerobot_alert_contact.default.id
  }
}

resource "uptimerobot_monitor" "rss" {
  friendly_name = "FreshRSS"
  url           = "https://rss.sylvain.dev/i/"
  interval      = 300
  type          = "http"

  alert_contact {
    id = data.uptimerobot_alert_contact.default.id
  }
}

resource "uptimerobot_monitor" "personal" {
  friendly_name = "Personal website"
  url           = "https://sylvain.dev/"
  interval      = 300
  type          = "http"

  alert_contact {
    id = data.uptimerobot_alert_contact.default.id
  }
}

resource "uptimerobot_monitor" "nextcloud" {
  friendly_name = "Nextcloud"
  url           = "https://nuage.sylvain.dev/"
  interval      = 300
  type          = "http"

  alert_contact {
    id = data.uptimerobot_alert_contact.default.id
  }
}

resource "uptimerobot_monitor" "nas" {
  friendly_name = "NAS"
  url           = "https://nas.sylvainmetayer.fr/"
  interval      = 300
  type          = "http"
}

resource "uptimerobot_monitor" "alias_email" {
  friendly_name = "Alias Gandi"
  url           = "https://alias-gandi-angular.netlify.app/"
  interval      = 300
  type          = "http"
  alert_contact {
    id = data.uptimerobot_alert_contact.default.id
  }
}

resource "uptimerobot_monitor" "redirect" {
  friendly_name = "Redirect"
  url           = "https://r.sylvain.dev"
  interval      = 300
  type          = "http"

  alert_contact {
    id = data.uptimerobot_alert_contact.default.id
  }
}

resource "uptimerobot_monitor" "monica" {
  friendly_name = "CRM"
  url           = "https://crm.sylvain.dev"
  interval      = 300
  type          = "http"

  alert_contact {
    id = data.uptimerobot_alert_contact.default.id
  }
}

resource "uptimerobot_status_page" "main" {
  friendly_name = "Status"
  password      = var.status_page_password
  sort          = "down-up-paused"
  status        = "active"
  monitors      = [0]
}
