
################################################################################
# OUTPUT
################################################################################
output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = aws_acm_certificate_validation.this.certificate_arn
}

output "acm_certificate_status" {
  description = "Status of the certificate."
  value       = aws_acm_certificate.this.status
}

output "validation_r53_records" {
  value = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
}

/* name = {
  "devopscloudemos.tk" = {
    "name" = "_5772d7b9011668c87a8f4bc28c10b81b.devopscloudemos.tk."
    "record" = "_0e4495f03be6ccfe32c96bf6acc830ce.pmgvbzmzyk.acm-validations.aws."
    "type" = "CNAME"
  }
  "www.devopscloudemos.tk" = {
    "name" = "_e6b0d7cf1dfdd870581e3be1c2d00147.www.devopscloudemos.tk."
    "record" = "_2f3d1bb2e5cb2e8d64540969254610f2.stwyzjdjkd.acm-validations.aws."
    "type" = "CNAME"
  }
} */