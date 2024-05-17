resource "godaddy-dns_record" "my-cname" {
  domain = var.domain
  type   = var.type
  name   = var.name
  ttl    = 3600
  data = var.data
}