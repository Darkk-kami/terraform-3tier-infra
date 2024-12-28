output "account_id" {
  value     = data.aws_caller_identity.current.account_id
  sensitive = true
}

output "secret" {
  value     = local.secret_data
  sensitive = true
}

output "ec2_poilicy" {
  value = aws_iam_policy.ec2_policy
}
