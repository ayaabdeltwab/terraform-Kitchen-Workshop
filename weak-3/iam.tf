# IAM user Taha with read access to logs/
resource "aws_iam_user" "taha" {
  name = "taha"
}

resource "aws_iam_policy" "taha_policy" {
  name        = "TahaReadPolicy"
  description = "Allow read access to logs folder"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "s3:GetObject",
        Effect   = "Allow",
        Resource = "arn:aws:s3:::frogtech-logs-bucket/logs/*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "taha_attach" {
  user       = aws_iam_user.taha.name
  policy_arn = aws_iam_policy.taha_policy.arn
}

# IAM user Mostafa with write access to the entire bucket
resource "aws_iam_user" "mostafa" {
  name = "mostafa"
}

resource "aws_iam_policy" "mostafa_policy" {
  name        = "MostafaWritePolicy"
  description = "Allow write access to the entire bucket"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "s3:PutObject",
        Effect   = "Allow",
        Resource = "arn:aws:s3:::frogtech-logs-bucket/*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "mostafa_attach" {
  user       = aws_iam_user.mostafa.name
  policy_arn = aws_iam_policy.mostafa_policy.arn
}