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