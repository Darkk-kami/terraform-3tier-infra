resource "aws_route53_health_check" "primary_rds_health_check" {
  fqdn              = var.primary_db.domain
  type              = "TCP"
  port              = 3306
  failure_threshold = 3
}

resource "aws_route53_health_check" "secondary_rds_health_check" {
  fqdn              = var.secondary_db.domain
  type              = "TCP"
  port              = 3306
  failure_threshold = 3
}

resource "aws_route53_record" "primary_rds_record" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "db.example.com"
  type    = "CNAME"
  ttl     = 60

  records = [var.primary_db.endpoint]

  health_check_id = aws_route53_health_check.primary_rds_health_check.id

  failover_routing_policy {
    type = "PRIMARY"
  }

  set_identifier = "primary"
}

resource "aws_route53_record" "secondary_rds_record" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "db.example.com"
  type    = "CNAME"
  ttl     = 60

  records = [var.secondary_db.endpoint]

  health_check_id = aws_route53_health_check.secondary_rds_health_check.id

  failover_routing_policy {
    type = "SECONDARY"
  }

  set_identifier = "secondary"
}

