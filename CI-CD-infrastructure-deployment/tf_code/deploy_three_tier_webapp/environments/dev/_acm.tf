################################################################################
# ACM
################################################################################
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "4.3.1"

  domain_name               = trimsuffix(data.aws_route53_zone.this.name, ".")
  zone_id                   = data.aws_route53_zone.this.zone_id
  subject_alternative_names = var.subject_alternative_names
  wait_for_validation       = true
  validation_timeout        = "10m"

  tags = {
    Name = var.route53_zone_name
  }

  depends_on = [module.vpc]
}
