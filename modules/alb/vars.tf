variable "vpc_id" {
  description = "The ID of the VPC where resources will be deployed."
  type        = string
}

variable "alb_subnets" {
  description = "List of subnet IDs for the Application Load Balancer."
  type        = list(string)
}

variable "environment" {
  description = "The environment for the deployment (e.g., dev, staging, prod)."
  type        = string
}

variable "health_check_path" {
  description = "Path for the ALB target group health check."
  type        = string
  default     = "/"
}

variable "health_check_interval" {
  description = "Interval (in seconds) between health checks."
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Timeout (in seconds) for each health check."
  type        = number
  default     = 5
}

variable "healthy_threshold" {
  description = "Number of consecutive health checks required to mark the target as healthy."
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "Number of consecutive health checks required to mark the target as unhealthy."
  type        = number
  default     = 2
}
