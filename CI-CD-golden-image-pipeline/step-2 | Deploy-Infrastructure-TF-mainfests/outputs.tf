################################################################################
# OUTPUTS - golden_ami_pipeline
################################################################################
output "ami_clone_http_url" {
  description = "URL to use for cloning the repository over HTTPS"
  value       = module.golden_ami_pipeline.clone_http_url
}

output "ami_clone_ssh_url" {
  description = "URL to use for cloning the repository over SSH."
  value       = module.golden_ami_pipeline.clone_ssh_url
}

output "ami_cb_project_names" {
  description = "Names of all codebuild projects"
  value       = module.golden_ami_pipeline.codebuild_project_names
}

output "ami_cb_service_role_arn" {
  description = "Codebuild project service role arn"
  value       = module.golden_ami_pipeline.codebuild_project_service_role_arn
}

output "ami_cp_arn" {
  description = "codepipeline ARN"
  value       = module.golden_ami_pipeline.codepipeline_arn
}

output "ami_cp_service_role_arn" {
  description = "Codepipeline service role arn"
  value       = module.golden_ami_pipeline.codepipeline_service_role_arn
}

################################################################################
# OUTPUTS - inspector
################################################################################
output "inspector_parameter_store_template_arn" {
  value = module.inspector_ec2_instance.parameter_store_template_arn
}

output "inspector_parameter_store_email_contact" {
  value = module.inspector_ec2_instance.parameter_store_email_contact
}

output "inspector_parameter_store_target_arn" {
  value = module.inspector_ec2_instance.parameter_store_target_arn
}

output "assessment_target_arn" {
  value = module.inspector_ec2_instance.assessment_target_arn
}

output "assessment_template_arn" {
  value = module.inspector_ec2_instance.assessment_template_arn
}

################################################################################
# OUTPUTS - slack
################################################################################
output "notification_rule_arns" {
  description = "List of codestar notification rule ARNs for pipeline status"
  value       = module.slack_notification.pipeline_notification_rule_arns
}

output "slack_stack_id" {
  description = "The unique ID for Cloudformation stack used to setup slack integration"
  value       = module.slack_notification.stack_id
}

output "configuration_arn" {
  description = "The ARN of the Chatbot Slack configuration"
  value       = module.slack_notification.configuration_arn
}

