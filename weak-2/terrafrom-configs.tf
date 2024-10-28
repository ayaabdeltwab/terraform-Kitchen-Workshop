terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "ayaterrbucket"
    key    = "terraform.statfile"
    region = "us-east-1"
  }
}