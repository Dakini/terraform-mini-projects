terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.59.0"
    }
  }
  backend "s3" {
    region = "eu-west-2"
    bucket = "tf-state-bucket-3"
    key    = "ml-deployment.tfstate"
  }
}

provider "aws" {
  # Configuration options
  region = var.aws_region

}

module "lambda" {
  source      = "./modules/lambda"
  environment = var.environment
}

module "api_gateway" {
  source            = "./modules/api_gateway"
  environment       = var.environment
  lambda_invoke_arn = module.lambda.lambda_invoke_arn

}