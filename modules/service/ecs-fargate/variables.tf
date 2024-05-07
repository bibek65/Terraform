variable "vpc_id" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}
