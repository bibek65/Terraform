module "frontend" {

  source = "../s3"

}

module "frontend_cloudfront" {
  depends_on = [module.frontend]
  source     = "../cloudfront"

}

module "cloudflare" {
  source = "../cloudflare"

  cloudfront_domain_name = module.frontend_cloudfront.domain_name

}
