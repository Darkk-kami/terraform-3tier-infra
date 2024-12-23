# Create a Virtual Private Cloud (VPC)
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = var.dns_hostnames
  tags = {
    Name        = "${var.environment}-vpc"
    Environemnt = var.environment
  }
}

# Fetch available AZs in the chosen region
data "aws_availability_zones" "available_azs" {
  state = "available"
}

# Calculate effective AZs and limit based on the region's available AZs
locals {
  effective_azs = min(var.desired_azs, length(data.aws_availability_zones.available_azs.names))
  az_list       = slice(data.aws_availability_zones.available_azs.names, 0, local.effective_azs)
}

# **************** Subnet Creation (Public and Private) ********************* #

# Subnet data for public and private subnets
locals {
  public_subnets = [
    for idx in range(var.public_subnets_no) : {
      idx      = idx
      name     = "public"
      cidr_add = 100 + idx
    }
  ]
  private_subnets = [
    for idx in range(var.private_subnets_no) : {
      idx      = idx
      name     = "private"
      cidr_add = idx
    }
  ]
  # Combines both public and private subnet definitions into one map with unique keys
  subnet_definitions = merge(
    { for idx, subnet in local.public_subnets : "public-${idx}" => subnet },
    { for idx, subnet in local.private_subnets : "private-${idx}" => subnet }
  )
}

# Create subnets dynamically
resource "aws_subnet" "subnets" {
  for_each          = local.subnet_definitions
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, each.value.cidr_add)
  availability_zone = local.az_list[each.value.idx % length(local.az_list)]
  tags = {
    Name        = "${var.environment}-${each.value.name}-subnet-${each.key}"
    Environment = var.environment
  }
}

# Create an Internet Gateway for external connectivity
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.environment}-igw"
    Environemnt = var.environment
  }
}

resource "aws_eip" "nat_eip" {
  tags = {
    Name        = "${var.environment}-nat-eip"
    Environment = var.environment
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  subnet_id     = aws_subnet.subnets["public-0"].id
  allocation_id = aws_eip.nat_eip.id
  tags = {
    Name        = "${var.environment}-nat-gw"
    Environment = var.environment
  }
}

# Create Route Tables
locals {
  combined = [
    { "type" = "public", "id" = aws_internet_gateway.internet_gateway.id },
    { "type" = "private", "id" = aws_nat_gateway.nat_gateway.id }
  ]
}

resource "aws_route_table" "route_tables" {
  for_each = { for idx, gateway in local.combined : idx => gateway }
  vpc_id   = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    # Use `nat_gateway_id` for NAT Gateways and `gateway_id` for others
    nat_gateway_id = each.value.type == "private" ? each.value.id : null
    gateway_id     = each.value.type == "public" ? each.value.id : null
  }
  tags = {
    Name        = "${var.environment}-${each.value.type}-route-table"
    Environment = var.environment
  }
}


# Associate public subnets with the route table
resource "aws_route_table_association" "public_route_table_association" {
  # Loop through public subnets to associate each with the public route table
  for_each       = { for key, subnet in local.subnet_definitions : key => aws_subnet.subnets[key] if subnet.name == "public" }
  route_table_id = aws_route_table.route_tables["0"].id
  subnet_id      = each.value.id
}

# Associate private subnets with the route table
resource "aws_route_table_association" "private_route_table_association" {
  for_each       = { for key, subnet in local.subnet_definitions : key => aws_subnet.subnets[key] if subnet.name == "private" }
  route_table_id = aws_route_table.route_tables["1"].id
  subnet_id      = each.value.id
}