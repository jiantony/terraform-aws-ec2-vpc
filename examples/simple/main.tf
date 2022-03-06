
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "ec2-vpc" {
  source = "app.terraform.io/Daffodil/ec2-vpc/aws"
  dept   = var.dept
}