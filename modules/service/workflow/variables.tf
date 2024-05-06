variable "bucket_name" {
  type = string
}

variable "vpc_subnet_module" {
  type = object({
    name               = string
    cidr_block         = string
    azs                = list(string)
    public_subnets     = list(string)
    private_subnets    = list(string)
    enable_nat_gateway = bool
  })
}

variable "domain_name" {
  type = string
}

