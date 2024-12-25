data "aws_secretsmanager_secret" "secret" {
  name = var.secret_name
}

data "aws_secretsmanager_secret_version" "secret_version" {
  secret_id = data.aws_secretsmanager_secret.secret.id
}

locals {
  secret_data = jsondecode(data.aws_secretsmanager_secret_version.secret_version.secret_string)
}

resource "aws_iam_policy" "my_secret_access" {
  name        = "MySecretAccess"
  description = "Allows access to my secret"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = data.aws_secretsmanager_secret.secret.arn
      }
    ]
  })
}

data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "db_instance_endpoint" {
  name        = "DB_Endpoint"
  description = "Retrieves DB Instance Endpoint"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "rds:DescribeDBInstances",
        "Resource" : "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:db:*"
      }
    ]
  })
}


resource "aws_iam_policy" "ec2_to_s3_policy" {
  name        = "EC2ToS3Policy"
  description = "Policy to allow EC2 instance access to a specific S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement : [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource = [
          var.source_bucket.arn,
          "${var.source_bucket.arn}/*"
        ]
      }
    ]
  })
}