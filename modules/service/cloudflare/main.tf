data "cloudflare_zone" "this" {
  name = "bibek65.tech"
}


data "external" "cloudfront_arn" {
  program = ["bash", "${path.module}/get_cloudfront_arn.sh"]
}

data "aws_cloudfront_distribution" "my_distribution" {
  id = data.external.cloudfront_arn.result["arn"]
}


resource "cloudflare_record" "my_cname" {
  zone_id = data.cloudflare_zone.this.id
  name    = var.domain_name
  value   = var.cloudfront_domain_name
  type    = "CNAME"
}
