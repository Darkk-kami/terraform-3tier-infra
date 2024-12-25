variable "rds_identifier" {
  description = "The identifier for the RDS instance"
  type        = string
}

variable "db_username" {
  description = "The master username for the database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The master password for the database"
  type        = string
  sensitive   = true
}


variable "private_subnet_ids" {
  description = "The DB subnet group name to associate with the RDS instance"
  type        = list(string)
}

variable "environment" {
  description = "The env prefix for tagging the RDS instance"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the security group will be created"
  type        = string
}

variable "allow_internet_access" {
  description = "Whether the security group allows internet access"
  type        = bool
  default     = false
}

variable "inbound_ports" {
  description = "A list of ports to allow inbound traffic for the security group"
  type        = list(number)
  default     = [3306]
}

variable "web_server_security_group_id" {
  description = "The security group ID for the web server to allow access"
  type        = string
}

variable "create_replica" {
  type    = bool
  default = false
}

variable "instance_role" {
  description = "Role of the RDS instance. Must be either 'primary' or 'replica'."
  type        = string

  validation {
    condition     = contains(["primary", "replica"], var.instance_role)
    error_message = "The instance_role variable must be either 'primary' or 'replica'."
  }
}

variable "source_db" {
  default = null
}
