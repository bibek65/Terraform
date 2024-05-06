variable "record_name" {
  type = string
  default = "api"
}

variable "cloudfront_record_name" {
  type = string
  default = "www"
}

variable "alb_dns_name" {
  type = string
}

variable "alb_zone_id" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "cloudfront_zone_id" {
  type = string
}

variable "cloudfront_domain_name" {
  type = string
}

