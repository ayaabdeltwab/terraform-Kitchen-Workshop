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