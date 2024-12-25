variable "cidr_block" {
  description = "cidr block for the vpc"
  default     = "10.0.0.0/16"
}

variable "dns_hostnames" {
  description = "Enable DNS Hostnames"
  type        = string
}

variable "desired_azs" {
  description = "Number of desired Availability Zones"
  type        = number
  validation {
    condition     = var.desired_azs >= 2
    error_message = "The number of AZs must be at least 2."
  }
}

variable "public_subnets_no" {
  description = "Number of public subnets needed"
  type        = number
}

variable "private_subnets_no" {
  description = "Number of private subnets needed"
  type        = number

  validation {
    condition     = var.private_subnets_no >= 2
    error_message = "The number of private subnets must be at least 2."
  }
}

variable "inbound_ports" {
  description = "List of ports to allow inbound access."
  type        = list(number)
  default     = [22, 80, 443] # default ports
}


variable "environment" {
  description = "The environment for the VPC (e.g., dev, prod, staging)"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "The Region for the VPC"
  type        = string
  default     = "us-east-1"
}