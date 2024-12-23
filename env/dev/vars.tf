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

variable "region" {
  description = "Region for infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "create_custom_domain" {
  type    = bool
  default = false
}