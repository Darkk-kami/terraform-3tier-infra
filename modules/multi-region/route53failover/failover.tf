terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.primary, aws.secondary]
    }
  }
}

data "aws_region" "primary_region" {
  provider = aws.primary
}

data "aws_region" "secondary_region" {
  provider = aws.secondary
}

resource "aws_route53_zone" "private" {
  name = "${var.environment}-private.zone"

  vpc {
    vpc_id     = var.primary_vpc_id
    vpc_region = data.aws_region.primary_region.name
  }

  vpc {
    vpc_id     = var.secondary_vpc_id
    vpc_region = data.aws_region.secondary_region.name
  }
}

resource "aws_route53_health_check" "primary" {
  type                            = "CLOUDWATCH_METRIC"
  insufficient_data_health_status = "Healthy"
  cloudwatch_alarm_name           = var.primary_rds_cloud_watch_alarm.alarm_name
  cloudwatch_alarm_region         = data.aws_region.primary_region.name
}

resource "aws_route53_health_check" "secondary" {
  type                            = "CLOUDWATCH_METRIC"
  insufficient_data_health_status = "Healthy"
  cloudwatch_alarm_name           = var.secondary_rds_cloud_watch_alarm.alarm_name
  cloudwatch_alarm_region         = data.aws_region.secondary_region.name
}

resource "aws_route53_record" "primary" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "db.${aws_route53_zone.private.name}"
  type    = "CNAME"

  records = [var.primary_db.endpoint]
  ttl     = "300"

  failover_routing_policy {
    type = "PRIMARY"
  }

  set_identifier = "primary"

  health_check_id = aws_route53_health_check.primary.id
}

resource "aws_route53_record" "secondary" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "db.${aws_route53_zone.private.name}"
  type    = "CNAME"


  records = [var.secondary_db.endpoint]
  ttl     = "300"

  failover_routing_policy {
    type = "SECONDARY"
  }

  set_identifier = "secondary"

  health_check_id = aws_route53_health_check.secondary.id
}
