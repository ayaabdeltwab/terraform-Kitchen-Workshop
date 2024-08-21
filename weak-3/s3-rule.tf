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
# Create a logs directory 
resource "aws_s3_object" "logs_dir" {
  bucket = aws_s3_bucket.task3.id
  content_type = "application/x-directory"
  key    = "logs/"
}
# Create a outgoing directory 
resource "aws_s3_object" "outgoing_dir" {
  bucket = aws_s3_bucket.task3.id
  content_type = "application/x-directory"
  key    = "outgoing/"
}
# Create a incomming directory 
resource "aws_s3_object" "incomming_dir" {
  bucket = aws_s3_bucket.task3.id   
  content_type = "application/x-directory"
  key    = "incomming/"
}
# Lifecycle Rule for /log directory
resource "aws_s3_bucket_lifecycle_configuration" "log_lifecycle" {
  bucket = aws_s3_bucket.task3.id

  rule {
    id     = "logs"
    status = "Enabled"

    filter {
      prefix = "logs/"
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
   timeouts {
    create = "10m"
    delete = "10m"
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