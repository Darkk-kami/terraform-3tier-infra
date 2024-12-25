# Variable for the deployment environment (e.g., dev, staging, prod)
variable "environment" {
  description = "The environment in which the infrastructure is being deployed."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "The environment must be one of 'dev', 'staging', or 'prod'."
  }
}

variable "primary_cidr_block" {
  description = "This is the cidr Block for the Primary VPC"
  type        = string
  default     = "10.0.0.0/16"
}


variable "secondary_cidr_block" {
  description = "The CIDR block for the secondary VPC (Must not overlap with Primary)"
  type        = string
  default     = "10.11.0.0/16"
}


variable "primary_region" {
  description = "Region for infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "secondary_region" {
  description = ""
  type        = string
  default     = "us-east-2"
}

variable "create_custom_domain" {
  type    = bool
  default = false
}

variable "secret_name" {
  type = string
}

variable "rds_identifier" {
  type    = string
  default = "my-rds-instance"
}

variable "domain_name" {
  description = "The domain name for the hosted zone and records."
  type        = string
}