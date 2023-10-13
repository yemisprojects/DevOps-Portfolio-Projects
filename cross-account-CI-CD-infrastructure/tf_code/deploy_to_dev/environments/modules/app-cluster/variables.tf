variable "env" {
  description = "Environment"
  type        = string
}

################################################################################
# LAUNCH TEMPLATE
################################################################################
variable "launch_template_name_prefix" {
  description = "Name prefix of Launch template"
  type        = string
  default     = "app-lt"
}

variable "image_id" {
  description = "The AMI from which to launch the instance"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}

# variable "key_name" {
#   description = "launch template Key name for ec2 Key Pair"
#   type        = string
# }

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
}

variable "lt_user_data" {
  description = "base64-encoded user data to provide when launching the instance"
  type        = any
}

variable "vpc_zone_identifier" {
  description = "List of subnet IDs to launch resources in"
  type        = list(string)
}

################################################################################
# APP AUTOSCALING GROUP
################################################################################
variable "asg_name" {
  description = "Name of the Auto Scaling Group"
  type        = string
  default     = "app-asg"
}

variable "target_group_arns" {
  description = "target_group ARNs for use with Application Load Balancer"
  type        = list(string)
}

variable "asg_sns_subscription_email" {
  description = "Email for receiving asg and CW alarm notifications"
  type        = string
}

variable "lb_arn_suffix" {
  description = "ARN suffix of load balancer"
  type        = string
}

variable "target_group_arn_suffix" {
  description = "ARN suffixes of target group"
  type        = string
}

variable "asg_max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type = number
  default = 6
}

variable "asg_min_size" {
  description = "Maximum size of the Auto Scaling Group"
  type = number
  default = 2
}

variable "desired_capacity" {
  description = "Number of Amazon EC2 instances that should be running in the Auto Scaling Group"
  type = number
  default = 2
}
