################################################################################
# APP AUTOSCALING GROUP
################################################################################
output "asg_name" {
  description = "Auto-scaling group name"
  value       = aws_autoscaling_group.app.name
}

output "asg_arn" {
  description = "Auto-scaling group arn"
  value       = aws_autoscaling_group.app.name
}

output "asg_sns_topic" {
  description = "The ARN of the SNS topic for asg notifications"
  value = aws_sns_topic.asg.arn
}

################################################################################
# LAUNCH TEMPLATE
################################################################################
output "lt_arn" {
  description = "The ARN of the launch template"
  value = aws_launch_template.app_server.arn
}

output "lt_latest_version" {
  description = "The latest version of the launch template"
  value = aws_launch_template.app_server.latest_version
}

output "app_servers_instance_profile" {
  description = "The ARN assigned by AWS to the EC2 instance profile"
  value = aws_iam_instance_profile.ec2.arn
}

output "app_servers_iam_role" {
  description = "The IAM role ARN of EC2 instance profile"
  value = aws_iam_role.ec2_ssm.arn
}