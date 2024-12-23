resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu-high-${var.asg.name}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = 75
  alarm_description   = "This metric monitors CPU utilization and triggers scaling actions."

  dimensions = {
    AutoScalingGroupName = var.asg.name
  }

  alarm_actions = [var.asg_policy.scale_up]
  ok_actions    = [var.asg_policy.scale_down]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu-low-${var.asg.name}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "This metric monitors CPU utilization and triggers scaling actions."

  dimensions = {
    AutoScalingGroupName = var.asg.name
  }

  alarm_actions = [var.asg_policy.scale_down]
}


# resource "aws_cloudwatch_metric_alarm" "alb_5xx_error_rate" {
#   alarm_name          = "alb-5xx-error-rate-${var.alb_name}"
#   comparison_operator = "GreaterThanThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "5XXErrorRate"
#   namespace           = "AWS/ApplicationELB"
#   period              = "60"
#   statistic           = "Average"
#   threshold           = 5    # Set your threshold (e.g., if error rate exceeds 5%)

#   alarm_description   = "This metric monitors the ALB 5xx error rate."

#   dimensions = {
#     LoadBalancer = var.alb_name
#   }

#   alarm_actions = [aws_sns_topic.alarm_notifications.arn]
#   ok_actions    = [aws_sns_topic.ok_notifications.arn]    
# }
