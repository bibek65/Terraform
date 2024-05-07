module "app" {
  bucket_name = "bibekaws-s3-bucket"
  source      = "./modules/service/workflow"
  vpc_subnet_module = {
    name               = "vpc-subnet-network"
    cidr_block         = "10.30.0.0/16"
    azs                = ["us-east-1a", "us-east-1b", "us-east-1c"]
    public_subnets     = ["10.30.0.0/24", "10.30.1.0/24", "10.30.2.0/24"]
    private_subnets    = ["10.30.128.0/24", "10.30.129.0/24", "10.30.130.0/24"]
    enable_nat_gateway = true
  }
  domain_name = "myapp.com"
  db_password = "securepassword123"
}




