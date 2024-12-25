module "policy" {
  source        = "./policy"
  secret_name   = var.secret_name
  region        = var.region
  source_bucket = var.source_bucket
}

resource "aws_iam_role" "secret_role" {
  name = "ec2-secrets-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_secret_policy" {
  role       = aws_iam_role.secret_role.name
  policy_arn = module.policy.secret_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_rds_describe_policy" {
  role       = aws_iam_role.secret_role.name
  policy_arn = module.policy.rds_describe_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.secret_role.name
  policy_arn = module.policy.ec2_to_s3_policy.arn
}

# Instance profile to use the role
resource "aws_iam_instance_profile" "instance_profile" {
  name = "ec2-role"
  role = aws_iam_role.secret_role.name
}

