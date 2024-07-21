terraform {
  backend "s3" {
    bucket  = "tf-state-mlops-zoomcamp"
    key     = "static-website.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }
}

provider "aws" {
  region = "eu-west-2"
}