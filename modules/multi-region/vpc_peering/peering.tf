terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.primary, aws.secondary]
    }
  }
}

data "aws_region" "accepter" {
  provider = aws.secondary
}


resource "aws_vpc_peering_connection" "request_connection" {
  provider    = aws.primary
  vpc_id      = var.vpc_requester
  peer_vpc_id = var.vpc_accepter
  peer_region = data.aws_region.accepter.name
  auto_accept = false
}

resource "aws_vpc_peering_connection_accepter" "accept_connection" {
  provider                  = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.request_connection.id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_options" "vpc_connection_options_requester" {
  provider                  = aws.primary
  vpc_peering_connection_id = aws_vpc_peering_connection.request_connection.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [aws_vpc_peering_connection_accepter.accept_connection]
}

resource "aws_vpc_peering_connection_options" "vpc_connection_options_accepter" {
  provider                  = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.request_connection.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [aws_vpc_peering_connection_accepter.accept_connection]
}