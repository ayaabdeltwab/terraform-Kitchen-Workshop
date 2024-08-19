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
resource "aws_s3_bucket" "task3" {
  bucket              = "s3-task3"
  force_destroy       = true
  object_lock_enabled = false

  tags = {
    Name        = "s3-task3"
    Environment = var.Environment
    Owner       = var.Owner
  }
}
# Create a log directory 
resource "aws_s3_object" "log_dir" {
  bucket = aws_s3_bucket.task3.id
  key    = "log/"
}
# Create a outgoing directory 
resource "aws_s3_object" "outgoing_dir" {
  bucket = aws_s3_bucket.task3.id
  key    = "outgoing/"
}
# Create a incomming directory 
resource "aws_s3_object" "incomming_dir" {
  bucket = aws_s3_bucket.task3.id
  key    = "incomming/"
}
# Lifecycle Rule for /log directory
resource "aws_s3_bucket_lifecycle_configuration" "log_lifecycle" {
  bucket = aws_s3_bucket.task3.id

  rule {
    id     = "log-transition"
    status = "Enabled"

    filter {
      prefix = "log/"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    transition {
      days          = 180
      storage_class = "DEEP_ARCHIVE"
    }

    expiration {
      days = 365
    }
  }
}
# Lifecycle Rule for /outgoing directory with specific tag
resource "aws_s3_bucket_lifecycle_configuration" "outgoing_lifecycle" {
  bucket = aws_s3_bucket.task3.id

  rule {
    id     = "outgoing-transition"
    status = "Enabled"

    filter {
      and {
        prefix = "outgoing/"
        tags = {
          "notDeepArchive" = "true"
        }
      }
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}
# Lifecycle Rule for /incoming directory with specific size conditions
resource "aws_s3_bucket_lifecycle_configuration" "incoming_lifecycle" {
  bucket = aws_s3_bucket.task3.id

  rule {
    id     = "incoming-transition"
    status = "Enabled"

    filter {
      and {
        prefix = "incoming/"
        object_size_greater_than = 1 * 1024 * 1024       # 1MB
        object_size_less_than    = 1 * 1024 * 1024 * 1024 # 1GB
      }
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}

kkkk
lll; 
