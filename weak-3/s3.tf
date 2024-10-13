# Create S3 bucket : 
resource "aws_s3_bucket" "frogtech" {
  bucket = "frog-tech"

  # Apply common tags
  tags = {
    Environment = "terraformChamps"
    Owner       = "aya"
  }

  # Force destroy even if the bucket is not empty
  force_destroy = true

}

# enable versioning :
resource "aws_s3_bucket_versioning" "versioning_frogtech" {
  bucket = aws_s3_bucket.frogtech.id
  versioning_configuration {
    status = "Enabled"
  }
}

# enable public access for s3
resource "aws_s3_bucket_public_access_block" "frogtech" {
  bucket = aws_s3_bucket.frogtech.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable SSE-S3 encryption with bucket key enabled
resource "aws_s3_bucket_server_side_encryption_configuration" "frogtech_encryption" {
  bucket = aws_s3_bucket.frogtech.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"  # Using SSE-S3 (AES-256 encryption)
    }
    bucket_key_enabled = true
  }
}

# Create a logs directory
resource "aws_s3_object" "log" {
  bucket = aws_s3_bucket.frogtech.bucket
  key    = "logs/"
  acl    = "private"

}