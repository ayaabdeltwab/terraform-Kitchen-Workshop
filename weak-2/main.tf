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

# Create S3 bucket with name, force_destroy set to true, and tags
resource "aws_s3_bucket" "task2" {
  bucket              = "s3-task2"
  force_destroy       = true
  object_lock_enabled = false

  tags = {
    Name        = "s3-task2"
    Environment = var.Environment
    Owner       = var.Owner
  }
}
# Create a logs directory 
resource "aws_s3_object" "logs_dir" {
  bucket = aws_s3_bucket.task2.id
  key    = "logs/"
}
# Enable versioning on the S3 bucket
resource "aws_s3_bucket_versioning" "versioning_bucket1" {
  bucket = aws_s3_bucket.task2.id
  versioning_configuration {
    status = "Enabled"
  }
}
# Bucket Policy to Allow IAM User to Upload Objects Only in logs/
data "aws_iam_policy_document" "upload-objects" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["data.aws_iam_user.iam_user.arn"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.task2.arn,
      "${aws_s3_bucket.task2.arn}/*",
    ]
  }
}



