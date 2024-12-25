variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "primary_vpc_id" {
  description = "The VPC ID for the primary region"
  type        = string
}

variable "secondary_vpc_id" {
  description = "The VPC ID for the secondary region"
  type        = string
}

variable "primary_rds_cloud_watch_alarm" {
  description = "The CloudWatch alarm object for the primary RDS instance"
  type = object({
    alarm_name = string
  })
}

variable "secondary_rds_cloud_watch_alarm" {
  description = "The CloudWatch alarm object for the secondary RDS instance"
  type = object({
    alarm_name = string
  })
}

variable "primary_db" {
  description = "The primary database object containing endpoint and zone ID"
  type = object({
    endpoint       = string
    hosted_zone_id = string
  })
}

variable "secondary_db" {
  description = "The secondary database object containing endpoint and zone ID"
  type = object({
    endpoint       = string
    hosted_zone_id = string
  })
}
