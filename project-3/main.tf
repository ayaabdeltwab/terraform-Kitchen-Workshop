terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"  
    }
  }
  backend "s3" {
    bucket = "ayaterraformbucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}
# Create variables 
variable "Environment" {
  description = "The environment for the S3 bucket"
  default     = "terraformChamps"
}
variable "Owner" {
  description = "The owner of the S3 bucket"
  default     = "Ayaa"
}
