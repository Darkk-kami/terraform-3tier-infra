resource "aws_security_group" "sg" {
  description = "Allow TLS traffic inbound and all outbound"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  for_each                     = { for idx, port in var.inbound_ports : idx => port }
  security_group_id            = aws_security_group.sg.id
  cidr_ipv4                    = var.allow_internet_access ? var.inbound_traffic : null
  referenced_security_group_id = var.allow_internet_access ? null : var.security_group_ref_id
  from_port                    = each.value
  to_port                      = each.value
  ip_protocol                  = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "app_allow_all_outbound_alb" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
