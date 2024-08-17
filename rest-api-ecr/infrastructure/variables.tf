variable "aws_region" {
  description = "region of the aws"
  default     = "eu-west-2"
}

variable "environment" {
  description = "description of environment i.e. prod /dev"
  default     = "dev"
}

variable "docker_image_local_path" {
  default = "../src/Dockerfile"
}

variable "lambda_function_local_path" {
  default = "../src/lambda_function.py"
}

variable "ecr_repo_name" {
  default = "ecr-api-image"
}