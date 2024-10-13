provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "ayaterrbucket"
    key    = "terraform.statfile"
    region = "us-east-1"
  }
}