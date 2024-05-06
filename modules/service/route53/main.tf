resource "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}


resource "aws_route53_record" "site_domain" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cloudfront" {

  name    = var.cloudfront_record_name
  type    = "A"
  zone_id = aws_route53_zone.hosted_zone.zone_id

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = true
  }
}