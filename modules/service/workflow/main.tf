module "frontend" {

  source      = "../s3"
  bucket_name = var.bucket_name

}

module "frontend_cloudfront" {
  depends_on     = [module.frontend]
  source         = "../cloudfront"
  bucket_name_id = module.frontend.bucket_name

}

module "vpc_subnet_module" {
  source = "terraform-aws-modules/vpc/aws"

  name            = var.vpc_subnet_module.name
  cidr            = var.vpc_subnet_module.cidr_block
  azs             = var.vpc_subnet_module.azs
  public_subnets  = var.vpc_subnet_module.public_subnets
  private_subnets = var.vpc_subnet_module.private_subnets

  enable_nat_gateway = var.vpc_subnet_module.enable_nat_gateway

}

module "bastion_host" {
  source     = "../bastion_host"
  depends_on = [module.vpc_subnet_module]
  subnet_id  = module.vpc_subnet_module.private_subnets[1]
}

module "asg" {
  source     = "../asg"
  depends_on = [module.vpc_subnet_module]
  subnet_ids = module.vpc_subnet_module.private_subnets
  vpc_id     = module.vpc_subnet_module.vpc_id

  cidr_block = module.vpc_subnet_module.vpc_cidr_block
  target_group_arn = module.ecs_ec2_alb.target_group_arns[0]
}



module "ecs_ec2_alb" {
  source = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name    = "ecs-ec2-alb"
  vpc_id  = module.vpc_subnet_module.vpc_id
  subnets = module.vpc_subnet_module.public_subnets
  load_balancer_type = "application"


  target_groups = [
    {
      backend_protocol = "HTTPS"
      backend_port     = 443
      target_type      = "instance"
    }
  ]


    https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = module.acm.certificate_arn
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

}


module "rds" {
  source = "../rds"
  depends_on = [module.vpc_subnet_module]
  subnet_ids = [module.vpc_subnet_module.private_subnets[0], module.vpc_subnet_module.private_subnets[1]]
}



module "route53" {
  source = "../route53"
  domain_name = var.domain_name
  alb_dns_name = module.ecs_ec2_alb.lb_dns_name
  alb_zone_id = module.ecs_ec2_alb.lb_zone_id
  cloudfront_domain_name = module.frontend_cloudfront.cloudfront_domain_name
  cloudfront_zone_id = module.frontend_cloudfront.hosted_zone_id
}

module "acm" {
  source = "../acm"
  depends_on = [module.route53]
  domain_name = var.domain_name
  alternative_name = "*.${var.domain_name}"
}

module "s3_endpoint" {
  source = "../s3-endpoint"
  depends_on = [module.vpc_subnet_module]
  vpc_id = module.vpc_subnet_module.vpc_id
  route_table_id = module.vpc_subnet_module.public_subnets[2]
}

module "waf" {
  source = "../waf"
  depends_on = [module.vpc_subnet_module]
  aws_lb_arn = module.ecs_ec2_alb.lb_arn
  cloudfront_distribution_arn = module.frontend_cloudfront.distribution_arn
}

module "secret_manager" {
  source = "../secret-manager"
  db_password = var.db_password
}

module "email-ses"{
  source = "../email-ses"
}

module "ecs-fargate" {
  source = "../ecs-fargate"
  depends_on = [module.vpc_subnet_module]
  vpc_id = module.vpc_subnet_module.vpc_id
  cidr_block = module.vpc_subnet_module.vpc_cidr_block
  public_subnets = [module.vpc_subnet_module.public_subnets[0]]
}




















