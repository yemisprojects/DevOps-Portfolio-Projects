locals {
  asg_name = "${var.asg_name}-${var.env}"
  lt_name = "${var.launch_template_name_prefix}-${var.env}"
  resource_label = "${var.lb_arn_suffix}/${var.target_group_arn_suffix}"
}

################################################################################
# LAUNCH TEMPLATE
################################################################################
resource "aws_launch_template" "app_server" {

  name          = local.lt_name
  description   = "app servers launch template"
  ebs_optimized = true

  image_id               = var.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids 
  # key_name               = var.key_name
  update_default_version = true
  user_data              = var.lt_user_data

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2.name
  }

  monitoring {
    enabled = true
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = 25
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      ManagedBy   = "Terraform"
      CreatedFrom = "ASG"
      Name        = "asg-node"
    }
  }

}

################################################################################
# INSTANCE PROFILE
################################################################################
resource "aws_iam_instance_profile" "ec2" {
  name = "ec2-ssm"
  role = aws_iam_role.ec2_ssm.name
}

resource "aws_iam_role" "ec2_ssm" {
  name                = "ec2_ssm"
  description         = "Ec2 role for launch template instance profile"
  path                = "/"
  assume_role_policy  = data.aws_iam_policy_document.ec2.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}

data "aws_iam_policy_document" "ec2" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

################################################################################
# APP AUTOSCALING GROUP
################################################################################
resource "aws_autoscaling_group" "app" {

  name                      = local.asg_name
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  desired_capacity          = var.desired_capacity
  health_check_grace_period = 300
  health_check_type         = "ELB"
  vpc_zone_identifier       = var.vpc_zone_identifier 
  target_group_arns         = var.target_group_arns   

  launch_template { 
    id      = aws_launch_template.app_server.id
    version = aws_launch_template.app_server.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["desired_capacity"]
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "project"
    value               = "app-tf"
    propagate_at_launch = true
  }
}

################################################################################
# ASG SCALING POLICIES
################################################################################
resource "aws_autoscaling_policy" "asg_avg_cpu_util" {
  name                      = "avg-cpu-greater-than-xx"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.app.name
  estimated_instance_warmup = 180
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}

resource "aws_autoscaling_policy" "alb_requests_per_target" {
  name                      = "alb-target-requests-greater-than-yy"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.app.name
  estimated_instance_warmup = 120
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = local.resource_label
    }
    target_value = 10.0
  }
}

################################################################################
# ASG NOTIFICATIONS
################################################################################
resource "aws_autoscaling_notification" "this" {
  topic_arn   = aws_sns_topic.asg.arn
  group_names = [aws_autoscaling_group.app.name]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
}

resource "aws_sns_topic" "asg" {
  name = "asg-notifications-${var.env}"
}

resource "aws_sns_topic_subscription" "asg" {
  topic_arn = aws_sns_topic.asg.arn
  protocol  = "email"
  endpoint  = var.asg_sns_subscription_email
}