output "instance_profile" {
  value = aws_iam_instance_profile.instance_profile
}

output "secret" {
  value     = module.policy.secret
  sensitive = true
}