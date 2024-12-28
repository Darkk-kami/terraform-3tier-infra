terraform {
  required_version = ">= 1.10.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.82.0"
    }
  }

  backend "s3" {
    bucket = "terraformstatebucketeks"
    key    = "terraform/3tier"
    region = "us-east-1"
  }

}



provider "aws" {
  region = var.primary_region
  alias  = "primary"
}

provider "aws" {
  region = var.secondary_region
  alias  = "failover"
}
