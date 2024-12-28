variable "vpc_id" {
  description = "The VPC ID to associate with the security group"
  type        = string
}

variable "inbound_traffic" {
  description = "Cidr range to allow inbound traffic from"
  type        = string
  default     = "0.0.0.0/0"
}

variable "inbound_ports" {
  description = "List of inbound ports to allow on the security group"
  type        = list(number)
  default     = [80, 443]
}

variable "allow_internet_access" {
  type = bool
}

variable "security_group_ref_id" {
  type    = string
  default = null
}