output "alarm_sns_topic_arn" {
  description = "The ARN of the SNS topic for cloud watch alarms"
  value       = aws_sns_topic.cw_alarm.arn
}

output "asg_cpu_alarm_arn" {
  description = "ARN of the ASG CPU cloudwatch Metric Alarm"
  value = aws_cloudwatch_metric_alarm.asg_high_cpu.arn
}

output "alb_alarm_arn" {
  description = "ARN of the APP load balancer 4xx cloudWatch Metric Alarm"
  value = aws_cloudwatch_metric_alarm.alb_4xx_errors.arn
}






