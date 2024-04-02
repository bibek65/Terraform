data "cloudflare_zone" "this" {
  name = "bibek65.tech"
}



resource "cloudflare_record" "my_cname" {
  zone_id = data.cloudflare_zone.this.id
  name    = var.domain_name
  value   = var.cloudfront_domain_name
  type    = "CNAME"
}
