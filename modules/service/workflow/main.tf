module "frontend" {

  source = "../s3"

}

module "frontend_cloudfront" {
  depends_on = [module.frontend]
  source     = "../cloudfront"

}
