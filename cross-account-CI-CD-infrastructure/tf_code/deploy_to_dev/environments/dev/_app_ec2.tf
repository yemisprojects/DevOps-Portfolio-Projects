################################################################################
# APP SERVERS
################################################################################
module "app_cluster" {
  source = "../modules/app-cluster"

  env                        = var.env
  image_id                   = data.aws_ssm_parameter.latest_ami.value
  # key_name                   = var.key_name
  vpc_security_group_ids     = [module.backend_apps_sg.security_group_id]
  vpc_zone_identifier        = module.vpc.private_subnets
  target_group_arns          = module.alb.target_group_arns
  asg_sns_subscription_email = var.sns_subscription_email
  lb_arn_suffix              = module.alb.lb_arn_suffix
  target_group_arn_suffix    = module.alb.target_group_arn_suffixes[0]

  lt_user_data = base64encode(templatefile("${path.module}/user_data/install-app.tftpl",
    {
      db_port     = 3306
      db_name     = var.db_name
      db_username = local.db_username
      db_password = local.db_password
      db_endpoint = local.db_endpoint
    }
    )
  )

  depends_on = [module.vpc]
}

module "backend_apps_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.16.2"

  name        = "backend-apps-sg-${var.env}"
  description = "Security group for app EC2 instances in private subnet to DB instances"
  vpc_id      = module.vpc.vpc_id


  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]
  ingress_rules       = ["ssh-tcp", "http-80-tcp", "http-8080-tcp"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
}
