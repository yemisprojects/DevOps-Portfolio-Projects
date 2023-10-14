output "pipeline_notification_rule_arns" {
  description = "List of codestar notification rule ARNs for pipeline status"
  value       = [for p in aws_codestarnotifications_notification_rule.pipeline_status : p.arn]
}

output "stack_id" {
  description = "The unique identifier for the stack."
  value       = aws_cloudformation_stack.chatbot_slack_configuration.id
}

output "configuration_arn" {
  description = "The ARN of the Chatbot Slack configuration"
  value       = aws_cloudformation_stack.chatbot_slack_configuration.outputs.ConfigurationArn
}

output "chatbot_role" {
  description = "IAM role for AWS chatbot"
  value       = aws_iam_role.chatbot.arn
}