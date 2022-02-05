variable "backup_sftp_url" {
  type      = string
  sensitive = true
}

variable "status_page_password" {
  type        = string
  description = "Uptime robot page password"
  sensitive   = true
}
