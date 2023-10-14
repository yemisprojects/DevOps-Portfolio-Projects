variable "env" {
  description = "Environment"
  type        = string
}

variable "cw_sns_subscription_email" {
  description = "Email for receiving CW alarm notifications"
  type        = string
}

variable "autoscaling_group_name" {
  description = "Name of the autoscaling group"
  type        = string
}

variable "lb_arn_suffix" {
  description = "ARN suffix of our load balancer"
  type        = string
}

variable "app_fqdn" {
  description = "app fqdn to be monitored by CW synthetics canary"
  type        = string
}

variable "asg_high_cpu_threshold" {
  description = "ASG high CPU threshold"
  type = string
  default = "80"
}

variable "asg_scaling_adjustment" {
  description = "ASG policy scaling adjustment"
  type = number
  default = 2
}

variable "alb_4xx_errors_threshold" {
  description = "ALB 4xx error threshold"
  type = string
  default = "5"
}

