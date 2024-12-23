output "security_group_id" {
  description = "The ID of the Application Load Balancer security group"
  value       = aws_security_group.sg.id
}
