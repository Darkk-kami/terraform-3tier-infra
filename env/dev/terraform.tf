terraform {
  required_version = ">= 1.10.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.82.0"
    }
  }

  # backend "s3" {
  #   bucket = "yourterraformstatebucket"
  #   key    = "terraform/asg"
  #   region = "us-east-1"
  # }
}


provider "aws" {
  region = var.region
}
