output "account_id" {
  value     = data.aws_caller_identity.current.account_id
  sensitive = true
}

output "secret_policy" {
  value = aws_iam_policy.my_secret_access
}

output "secret" {
  value     = local.secret_data
  sensitive = true
}

output "rds_describe_policy" {
  value = aws_iam_policy.db_instance_endpoint
}

output "ec2_to_s3_policy" {
  value = aws_iam_policy.ec2_to_s3_policy
}