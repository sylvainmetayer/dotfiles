variable "backup_sftp_url" {
  type = string
}

variable "backend_bucket" {
  type = string
}

variable "scw_zone" {
  type = string
}

variable "scw_region" {
  default = "fr-par"
  type    = string
}

variable "status_page_password" {
  type        = string
  description = "Uptime robot page password"
}
