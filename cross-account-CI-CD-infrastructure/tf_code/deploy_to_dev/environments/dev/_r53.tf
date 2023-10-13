################################################################################
# ROUTE 53 ## UPDATE to create zone. # default admin user: admin101/password101
################################################################################

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "www.${data.aws_route53_zone.this.name}"
  type    = "A"
  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }

  depends_on = [module.vpc]
}
