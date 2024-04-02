terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.43.0"
    }
  }
}


provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["C:/Users/Dell/.aws/credentials"]
  shared_config_files      = ["~/.aws.config"]

  default_tags {
    tags = {
      Creator   = "bkarna65@gmail.com"
      Project   = "Intern"
      Deletable = "Yes"
    }
  }

}


