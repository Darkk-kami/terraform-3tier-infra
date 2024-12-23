output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "A list of IDs for the public subnets."
  value = [
    for key, subnet in aws_subnet.subnets :
    subnet.id if local.subnet_definitions[key].name == "public"
  ]
}

output "private_subnet_ids" {
  description = "A list of IDs for the private subnets."
  value = [
    for key, subnet in aws_subnet.subnets :
    subnet.id if local.subnet_definitions[key].name == "private"
  ]
}