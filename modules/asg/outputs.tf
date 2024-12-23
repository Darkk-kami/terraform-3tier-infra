output "asg" {
  description = "Auto Scaling Group details"
  value = {
    name = aws_autoscaling_group.web_servers.name
    id   = aws_autoscaling_group.web_servers.id
  }
}

output "scaling_policies" {
  description = "Scaling policies ARNs"
  value = {
    scale_up   = aws_autoscaling_policy.scale_up.arn
    scale_down = aws_autoscaling_policy.scale_down.arn
  }
}

output "alb_target_group_arn" {
  description = "ARN of the ALB Target Group"
  value       = var.alb_target_group.arn
}
