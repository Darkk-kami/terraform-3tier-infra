terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.primary, aws.secondary]
    }
  }
}


resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  provider            = aws.primary
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
  provider            = aws.primary
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


# RDS Cloud Watch alarms
resource "aws_cloudwatch_metric_alarm" "primary_rds_connections_alarm" {
  provider            = aws.primary
  alarm_name          = "rds-cpu-utilization-${var.primary_rds_instance_identifier}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 120
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "This metric monitors RDS Database connections"
  dimensions = {
    DBInstanceIdentifier = var.primary_rds_instance_identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "primary_rds_cpu_utilization_alarm" {
  provider            = aws.primary
  alarm_name          = "primary-cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 120
  statistic           = "Average"
  threshold           = 90
  alarm_description   = "Triggers when the primary RDS instance has high CPU utilization."
  dimensions = {
    DBInstanceIdentifier = var.primary_rds_instance_identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "secondary_rds_cpu_alarm" {
  provider            = aws.secondary
  alarm_name          = "rds-replica-lag-${var.secondary_rds_instance_identifier}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "ReplicaLag"
  namespace           = "AWS/RDS"
  period              = 120
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "This metric monitors replication lag on the secondary RDS instance"
  dimensions = {
    DBInstanceIdentifier = var.secondary_rds_instance_identifier
  }
}