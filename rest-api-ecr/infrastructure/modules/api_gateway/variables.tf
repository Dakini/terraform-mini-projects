variable "rest_gateway_name" {
  default = "test-api-name"
}

variable "stage_name" {
  default = "dev"
}

variable "lambda_function_arn" {
  description = "arn of the lambda function"
}

variable "path_part" {
  default = "resource"
}