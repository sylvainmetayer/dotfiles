data "healthchecksio_channel" "signal" {
  kind = "signal"
}

resource "healthchecksio_check" "backup_betisier" {
  name    = "Betisier"
  desc    = "Ensure backup of Betisier did run at least once per day."
  timeout = 86400 # 1 day
  grace   = 3600
  tags    = ["backup"]
  channels = [
    data.healthchecksio_channel.signal.id
  ]
}

resource "healthchecksio_check" "backup_nextcloud" {
  name    = "Nextcloud"
  desc    = "Ensure backup of Nextcloud did run at least once per day."
  timeout = 86400 # 1 day
  grace   = 3600
  tags    = ["backup"]
  channels = [
    data.healthchecksio_channel.signal.id
  ]
}

resource "healthchecksio_check" "backup_crm" {
  name    = "CRM"
  desc    = "Ensure backup of Monica did run at least once per day."
  timeout = 86400 # 1 day
  grace   = 3600
  tags    = ["backup"]
  channels = [
    data.healthchecksio_channel.signal.id
  ]
}

resource "healthchecksio_check" "backup_rss" {
  name    = "FreshRSS"
  desc    = "Ensure backup of FreshRSS did run at least once per day."
  timeout = 86400 # 1 day
  grace   = 3600
  tags    = ["backup"]
  channels = [
    data.healthchecksio_channel.signal.id
  ]
}

resource "healthchecksio_check" "backup_grocy" {
  name    = "Grocy"
  desc    = "Ensure backup of Grocy did run at least once per day."
  timeout = 86400 # 1 day
  grace   = 3600
  tags    = ["backup"]
  channels = [
    data.healthchecksio_channel.signal.id
  ]
}

resource "healthchecksio_check" "cron_crm" {
  name    = "CRM Schedule"
  desc    = "Ensure CRM cron ran"
  timeout = 3600
  grace   = 21600 # 6h
  tags    = ["cron"]
  channels = [
    data.healthchecksio_channel.signal.id
  ]
}

data "template_file" "healthcheck_urls" {
  template = file("${path.module}/templates/healthcheck_urls.yaml.tpl")
  vars = {
    betisier_url  = "${healthchecksio_check.backup_betisier.ping_url}"
    crm_url       = "${healthchecksio_check.backup_crm.ping_url}"
    nextcloud_url = "${healthchecksio_check.backup_nextcloud.ping_url}"
    rss_url       = "${healthchecksio_check.backup_rss.ping_url}"
    grocy_url     = "${healthchecksio_check.backup_grocy.ping_url}"
    cron_crm      = "${healthchecksio_check.cron_crm.ping_url}"
  }
}

resource "local_file" "healthcheck_config" {
  filename        = "${path.root}/../params/healthchecks_urls.yml"
  content         = data.template_file.healthcheck_urls.rendered
  file_permission = "0644"
}
