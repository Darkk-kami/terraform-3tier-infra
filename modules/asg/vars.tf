variable "desired_capacity" {
  description = "The desired number of instances in the Auto Scaling group."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The maximum size of the Auto Scaling group."
  type        = number
  default     = 5
}

variable "min_size" {
  description = "The minimum size of the Auto Scaling group."
  type        = number
  default     = 1
}

variable "private_subnet_ids" {
  description = "A list of subnet IDs where the Auto Scaling group will launch instances."
  type        = list(string)
}

variable "launch_template" {
  description = "Details of the launch template used by the Auto Scaling Group."
  type = object({
    id             = string
    latest_version = string
  })
}

variable "alb_target_group" {
  description = "Details of the target group for the Application Load Balancer."
  type = object({
    arn = string
  })
}

variable "environment" {
  type    = string
  default = "dev"
}
