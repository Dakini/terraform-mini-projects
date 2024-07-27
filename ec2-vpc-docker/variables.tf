variable "aws_region" {
  description = "aws region"
  default     = "eu-west-2"
}

variable "ssh-key-name" {
  description = "name of the ssh key for the ec2 instance"
  default     = "test-ec2"
}