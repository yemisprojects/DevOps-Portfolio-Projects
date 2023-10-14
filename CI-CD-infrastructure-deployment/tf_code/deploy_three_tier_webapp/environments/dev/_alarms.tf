################################################################################
# ASG notifications and cloudwatch alarms
################################################################################
module "app_alarms" {
  source = "../modules/alarms"

  env                       = var.env
  cw_sns_subscription_email = var.sns_subscription_email
  autoscaling_group_name    = module.app_cluster.asg_name
  lb_arn_suffix             = module.alb.lb_arn_suffix
  app_fqdn                  = aws_route53_record.www.fqdn
}
