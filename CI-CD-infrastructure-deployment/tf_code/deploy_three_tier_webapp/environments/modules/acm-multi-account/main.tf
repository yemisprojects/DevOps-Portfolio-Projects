# ######################################
# Get hosted zone in dns root account
# ######################################
data "aws_route53_zone" "public_zone" {
  provider     = aws.dns_act_owner
  name         = var.r53_zone_name
  private_zone = false
}

# ######################################
# Create Certificate
# ######################################
resource "aws_acm_certificate" "this" {
  domain_name       = var.acm_domain_name
  validation_method = "DNS"
  subject_alternative_names = var.acm_subject_alternate_names != null ? var.acm_subject_alternate_names : null
}

# ############################################################################
# Create AWS Route 53 Certificate Validation Record
# ############################################################################
resource "aws_route53_record" "validation_record" {
  provider = aws.dns_act_owner
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.public_zone.zone_id
}

# ######################################
# Create Certificate Validation
# ######################################
resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.validation_record : record.fqdn]

 timeouts {
    create = var.validation_timeout
  }
}

