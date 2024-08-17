terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.59.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = var.aws_region

}
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

module "ecr" {
  source                     = "./modules/ecr"
  aws_region                 = var.aws_region
  account_id                 = local.account_id
  docker_image_local_path    = var.docker_image_local_path
  lambda_function_local_path = var.lambda_function_local_path
  ecr_repo_name              = var.ecr_repo_name
}

module "lambda" {
  source     = "./modules/lambda"
  image_uri  = module.ecr.image_uri
  depends_on = [module.ecr]
}

module "api_gateway" {
  source = "./modules/api_gateway"
  lambda_function_arn = module.lambda.lambda_arn
  depends_on = [ module.lambda ]

}
output "invoke_arn" {
  value = module.api_gateway.invoke_arn
}