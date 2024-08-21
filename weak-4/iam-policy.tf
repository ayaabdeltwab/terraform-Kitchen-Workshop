# Create IAM user Ahmed with EC2 Administrator Policy
resource "aws_iam_user" "ahmed" {
  name = "Ahmed"
}

resource "aws_iam_user_policy_attachment" "ahmed_ec2_policy" {
  user       = aws_iam_user.ahmed.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# Create IAM user Mahmoud with S3 permissions restricted by IP
resource "aws_iam_user" "mahmoud" {
  name = "Mahmoud"
}

resource "aws_iam_user_policy" "mahmoud_s3_policy" {
  name   = "MahmoudS3Policy"
  user   = aws_iam_user.mahmoud.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject"
        ],
        "Resource" : "arn:aws:s3:::ayaterraformbucket/*",  
        "Condition" : {
          "IpAddress" : {
            "aws:SourceIp" : "49.205.35.242/32"  
          }
        }
      }
    ]
  })
}

# Create IAM user Mostafa
resource "aws_iam_user" "mostafa" {
  name = "Mostafa"
}

# Create IAM role for Mostafa with S3 GetObject access
resource "aws_iam_role" "mostafa_role" {
  name               = "MostafaS3Role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : aws_iam_user.mostafa.arn
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# Attach policy to the role for S3 GetObject access
resource "aws_iam_role_policy" "mostafa_s3_policy" {
  name   = "MostafaS3Policy"
  role   = aws_iam_role.mostafa_role.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::ayaterraformbucket/*" 
      }
    ]
  })
}

# Add inline policy to allow Mostafa to assume the role
resource "aws_iam_user_policy" "mostafa_assume_role_policy" {
  name   = "MostafaAssumeRolePolicy"
  user   = aws_iam_user.mostafa.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Resource" : aws_iam_role.mostafa_role.arn
      }
    ]
  })
}
