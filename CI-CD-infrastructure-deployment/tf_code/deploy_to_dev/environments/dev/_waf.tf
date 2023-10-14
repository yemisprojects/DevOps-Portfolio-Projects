################################################################################
# WAF
################################################################################
module "waf_alb" {
  source = "../modules/waf"

  web_acl_name   = "demo_alb_webacl-${var.env}"
  alb_arn        = module.alb.lb_arn
  waf_log_choice = "cloudwatch"
}