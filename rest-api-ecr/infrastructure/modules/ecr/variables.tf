variable "aws_region" {
  description = "region of ecr"
}

variable "account_id" {
  description = "account id"
}

variable "ecr_repo_name" {
  description = "repo name"
}

variable "ecr_image_tag" {
  default = "latest"
}

variable "docker_image_local_path" {
  description = "local path to docker image"

}
variable "lambda_function_local_path" {
  description = "local path to lambda_function"
}