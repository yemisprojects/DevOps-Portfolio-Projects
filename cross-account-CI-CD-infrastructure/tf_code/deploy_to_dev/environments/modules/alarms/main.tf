
################################################################################
# SNS SUBSCRIPTION
################################################################################
resource "aws_sns_topic" "cw_alarm" {
  name = "cloudwatch-alarms-${var.env}"
}

resource "aws_sns_topic_subscription" "cw_alarm" {
  topic_arn = aws_sns_topic.cw_alarm.arn
  protocol  = "email"
  endpoint  = var.cw_sns_subscription_email
}

################################################################################
# ASG ALARM
################################################################################
resource "aws_cloudwatch_metric_alarm" "asg_high_cpu" {
  alarm_name          = "asg-high-cpu"
  alarm_description   = "CW Alarm to scale out ASG if CPU is above 80%"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = var.asg_high_cpu_threshold
  ok_actions          = [aws_sns_topic.cw_alarm.arn]
  alarm_actions       = [aws_autoscaling_policy.high_cpu.arn, aws_sns_topic.cw_alarm.arn]

  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name 
  }
}

resource "aws_autoscaling_policy" "high_cpu" {
  name                   = "high-cpu"
  policy_type            = "SimpleScaling"
  scaling_adjustment     = var.asg_scaling_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = var.autoscaling_group_name 
}

################################################################################
# ALB ALARM
################################################################################
resource "aws_cloudwatch_metric_alarm" "alb_4xx_errors" {
  alarm_name          = "alb-http-4xx-errors"
  alarm_description   = "CW alarm to notify when ALB HTTP 4xx errors exceeds desired threshold"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = "2"
  evaluation_periods  = "3"
  metric_name         = "HTTPCode_Target_4XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "120"
  statistic           = "Sum"
  threshold           = var.alb_4xx_errors_threshold
  treat_missing_data  = "missing"
  ok_actions          = [aws_sns_topic.cw_alarm.arn]
  alarm_actions       = [aws_sns_topic.cw_alarm.arn]

  dimensions = {
    LoadBalancer = var.lb_arn_suffix 
  }
}

