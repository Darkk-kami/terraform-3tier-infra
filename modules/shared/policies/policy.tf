data "aws_secretsmanager_secret" "secret" {
  name = var.secret_name
}

data "aws_secretsmanager_secret_version" "secret_version" {
  secret_id = data.aws_secretsmanager_secret.secret.id
}

locals {
  secret_data = jsondecode(data.aws_secretsmanager_secret_version.secret_version.secret_string)
}

data "aws_caller_identity" "current" {}


resource "aws_iam_policy" "ec2_policy" {
  name        = "CombinedEC2Policy"
  description = "Combined policy for accessing Secrets Manager, RDS, and S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"],
        Resource = data.aws_secretsmanager_secret.secret.arn
      },
      {
        Effect   = "Allow",
        Action   = "rds:DescribeDBInstances",
        Resource = "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:db:*"
      },
      {
        Effect   = "Allow",
        Action   = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"],
        Resource = ["${var.source_bucket.arn}", "${var.source_bucket.arn}/*"]
      }
    ]
  })
}
