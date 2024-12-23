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
}

variable "public_subnets_no" {
  description = "Number of public subnets needed"
  type        = number
}

variable "private_subnets_no" {
  description = "Number of private subnets needed"
  type        = number
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
