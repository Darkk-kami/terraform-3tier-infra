output "primary_rds_connections_alarm" {
  description = "The CPU utilization alarm for the primary RDS instance."
  value       = aws_cloudwatch_metric_alarm.primary_rds_connections_alarm
}

output "primary_cpu_utilization_alarm" {
  description = "The high CPU utilization alarm for the primary RDS instance."
  value       = aws_cloudwatch_metric_alarm.primary_rds_cpu_utilization_alarm
}

output "secondary_rds_replica_lag_alarm" {
  description = "The replication lag alarm for the secondary RDS instance."
  value       = aws_cloudwatch_metric_alarm.secondary_rds_cpu_alarm
}
