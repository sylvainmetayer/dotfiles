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
