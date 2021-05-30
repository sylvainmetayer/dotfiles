output "gibbs_ipv4" {
  description = "IPV4 of VPS to create/update DNS entries"
  value = hcloud_server.server.ipv4_address
}
