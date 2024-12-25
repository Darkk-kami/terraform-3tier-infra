variable "asg" {
  default = null
}

variable "asg_policy" {
  default = null
}

# variable "alb_name" {


variable "primary_rds_instance_identifier" {
  description = "The identifier of the primary RDS instance"
  type        = string
}

variable "secondary_rds_instance_identifier" {
  description = "The identifier of the secondary RDS instance"
  type        = string
}

