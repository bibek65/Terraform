module "frontend" {

  source      = "../s3"
  bucket_name = var.domain_name

}

module "frontend_cloudfront" {
  depends_on = [module.frontend]
  source     = "../cloudfront"

  bucket_name_id = module.frontend.bucket_name

}

module "cloudflare" {
  source      = "../cloudflare"
  domain_name = var.domain_name

  cloudfront_domain_name = module.frontend_cloudfront.domain_name


}
