terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.60.0"
    }
  }
  backend "s3" {
    bucket = "tf-state-bucket-3"
    key    = "ec2-vpc-docker.tfstate"
    region = "eu-west-2"

  }
}

provider "aws" {
  # Configuration options
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
}
module "ec2" {
  source       = "./modules/ec2"
  shh-key-name = var.ssh-key-name
  vpc_id       = module.vpc.vpc_id
  public_subnet = module.vpc.public_subnet
}

output "ec2-ip" {
  value = module.ec2.ip
}
output "vpc-id" {
  value = module.vpc.vpc_id
}