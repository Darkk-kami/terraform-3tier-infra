output "launch_template" {
  value = aws_launch_template.launch_template
}

output "web_server_security_group_id" {
  value = module.security_group.security_group_id
}