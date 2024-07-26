terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.59.0"
    }
  }
  backend "s3" {
    bucket = "tf-state-bucket-3"
    key = "mlflow-state.tfstate"
    region = "eu-west-2"
  }
}

provider "aws" {
  # Configuration options
  region = var.aws_region
}

module "mlflow-db" {
  source = "./modules/rds"
}

module "s3-bucket" {
  source = "./modules/s3"
}



module "ec2-instance" {
  source = "./modules/ec2"
  filename = var.ssh-key
  mlflow-bucket-arn = module.s3-bucket.mlflow-bucket-arn
  depends_on = [ module.s3-bucket ]
}

output "ec2-ip" {
  value = module.ec2-instance.ec2-ip
}


output "rds-address" {
  value = module.mlflow-db.rds-ip
}