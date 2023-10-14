################################################################################
# ALB
################################################################################
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "8.2.1"

  name               = "app-alb-${var.env}"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  security_groups    = [module.app_alb_sg.security_group_id]
  subnets            = module.vpc.public_subnets

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  https_listeners = [

    {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = module.acm.acm_certificate_arn
      action_type     = "fixed-response"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Default message for request to root page"
        status_code  = "200"
      }
    }

  ]

  https_listener_rules = [

    {
      https_listener_index = 0
      priority             = 1
      actions = [
        {
          type               = "forward"
          target_group_index = 0
        }
      ]
      conditions = [{
        path_patterns = ["/*"]
      }]
    }

  ]

  target_groups = [
    {
      name_prefix          = "app-"
      backend_protocol     = "HTTP"
      backend_port         = 8080
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/login"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 5
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      stickiness = {
        enabled         = true
        cookie_duration = 3600
        type            = "lb_cookie"
      }
      protocol_version = "HTTP1"
    }
  ]

  depends_on = [module.vpc]

  lb_tags = {
    MyLoadBalancer = "app-lb"
  }

  http_tcp_listeners_tags = {
    MyLoadBalancerTCPListener = "app-alb-http-listener"
  }

  https_listeners_tags = {
    MyLoadBalancerHTTPSListener = "app-alb-https-listener"
  }

  https_listener_rules_tags = {
    MyLoadBalancerHTTPSListenerRule = "app-alb-https-rule-listener"
  }

}

################################################################################
# ALB SG
################################################################################
module "app_alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.16.2"

  name        = "app-alb-sg-${var.env}"
  description = "Security group for internet facing application load balancer to app EC2 instances"
  vpc_id      = module.vpc.vpc_id


  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  egress_cidr_blocks  = [module.vpc.vpc_cidr_block]
  egress_rules        = ["all-all"]
}