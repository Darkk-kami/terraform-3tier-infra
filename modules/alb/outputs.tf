output "alb_security_group_id" {
  value = module.security_group.security_group_id
}

output "alb_target_group" {
  value = aws_lb_target_group.asg_target_group
}

output "alb_dns" {
  value = aws_lb.alb.dns_name
}

output "alb_hosted_zone_id" {
  value = aws_lb.alb.zone_id
}