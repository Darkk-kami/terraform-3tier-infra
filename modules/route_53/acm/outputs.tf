output "acm_certificate_arn" {
  value = aws_acm_certificate.cert.arn
}

output "aws_acm_certificate_validation" {
  value = aws_acm_certificate.cert.domain_validation_options
}