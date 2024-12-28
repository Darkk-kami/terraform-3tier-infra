variable "vpc_requester" {
  description = "The VPC ID for the requester."
  type        = string
}

variable "vpc_accepter" {
  description = "The VPC ID for the accepter."
  type        = string
}

variable "requester_route_table_id" {
  description = "ID of the private route table in the requester VPC"
  type        = string
}

variable "accepter_route_table_id" {
  description = "ID of the private route table in the accepter VPC"
  type        = string
}


variable "vpc_requester_cidr" {
  description = "CIDR block of the requester VPC"
  type        = string
}

variable "vpc_accepter_cidr" {
  description = "CIDR block of the accepter VPC"
  type        = string
}