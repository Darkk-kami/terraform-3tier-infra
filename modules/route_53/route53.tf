module "acm_certificate" {
  source      = "./acm"
  domain_name = var.domain_name
}

data "aws_route53_zone" "selected_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in module.acm_certificate.aws_acm_certificate_validation :
    dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }
  zone_id = data.aws_route53_zone.selected_zone.id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 60
}

resource "aws_route53_record" "alb_record" {
  name    = var.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.selected_zone.zone_id

  alias {
    evaluate_target_health = false
    name                   = var.alb_dns
    zone_id                = var.alb_zone_id
  }
}
