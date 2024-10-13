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

# Create S3 bucket
resource "aws_s3_bucket" "frogtechlogs" {
  bucket = "frogtech-logs"

  # Force destroy even if the bucket is not empty
  force_destroy = true

  # Apply common tags
  tags = {
    Environment = "terraformChamps"
    Owner       = "aya"
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "versioning_frogtechlogs" {
  bucket = aws_s3_bucket.frogtechlogs.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Set bucket ownership to BucketOwnerPreferred
resource "aws_s3_bucket_ownership_controls" "frogtechlogs" {
  bucket = aws_s3_bucket.frogtechlogs.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Block public access to the bucket
resource "aws_s3_bucket_public_access_block" "frogtechlogs" {
  bucket = aws_s3_bucket.frogtechlogs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable SSE-S3 encryption with bucket key enabled
resource "aws_s3_bucket_server_side_encryption_configuration" "frogtechlogs_encryption" {
  bucket = aws_s3_bucket.frogtechlogs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"  # Using SSE-S3 (AES-256 encryption)
    }
    bucket_key_enabled = true
  }
}

# S3 Lifecycle rule to delete objects after 7 days
resource "aws_s3_bucket_lifecycle_configuration" "frogtechlogs_lifecycle" {
  bucket = aws_s3_bucket.frogtechlogs.id

  rule {
    id     = "log-expiration-rule"
    status = "Enabled"

    expiration {
      days = 7
    }
  }
}
