################################################################################
# DEV ENV BACCKEND OUTPUTS
################################################################################
output "dev_backend_arn" {
  description = "ARN of the bucket for S3 backend for dev env"
  value       = module.dev_backend.s3_bucket_arn
}

output "dev_dynamo_lock_arn" {
  description = "Arn of dynamodb table for remote state for dev env"
  value       = module.dev_backend.table_arn
}

################################################################################
# AWS_CHATBOT-SLACK OUTPUTS
################################################################################
output "notification_rule_arns" {
  description = "List of codestar notification rule ARNs for pipeline status"
  value       = module.slack_notification.pipeline_notification_rule_arns
}

output "chatbot_CFN_stack_id" {
  description = "The unique ID for Cloudformation stack used to setup slack integration"
  value       = module.slack_notification.stack_id
}

# output "slack_chatbot_config_arn" {
#   description = "The ARN of the Chatbot Slack configuration"
#   value       = module.slack_notification.configuration_arn
# }

################################################################################
# CODEBUILD/ECR OUTPUTS
################################################################################
output "ecr_repo_url" {
  description = "Url of ecr repository"
  value       = aws_ecr_repository.cb_image.repository_url
  # sensitive   = true
}

################################################################################
# DEV ACT IAM ROLE OUTPUTS
################################################################################
output "dev_cross_act_role_arn" {
  description = "Arn of cross account role in dev acct"
  value       = module.dev_cross_act_role.cross_act_role_arn
}


#
output "infracost_secretmanager_name" {
  description = "Name of secretmanager for infracost apikey"
  value = aws_secretsmanager_secret.infracost.name
}




################################################################################
# DEV ENV PIPELINE OUTPUTS
################################################################################
output "dev_cp_arn" {
  description = "codepipeline ARN"
  value       = module.dev_pipeline.codepipeline_arn
}

/*
output "dev_clone_http_url" {
  description = "URL to use for cloning the repository over HTTPS"
  value       = module.dev_pipeline.clone_http_url
}

output "dev_clone_ssh_url" {
  description = "URL to use for cloning the repository over SSH."
  value       = module.dev_pipeline.clone_ssh_url
}

output "dev_cb_project_names" {
  description = "Names of all codebuild projects"
  value       = module.dev_pipeline.codebuild_project_names
}

output "dev_cb_service_role_arn" {
  description = "Codebuild project service role arn"
  value       = module.dev_pipeline.codebuild_project_service_role_arn
}



output "dev_cp_service_role_arn" {
  description = "Codepipeline service role arn"
  value       = module.dev_pipeline.codepipeline_service_role_arn
}
 */





/*
################################################################################
# PROD-PIPELINE OUTPUTS
################################################################################
output "prod_clone_http_url" {
  description = "URL to use for cloning the repository over HTTPS"
  value       = module.prod_pipeline.clone_http_url
}

output "prod_clone_ssh_url" {
  description = "URL to use for cloning the repository over SSH."
  value       = module.prod_pipeline.clone_ssh_url
}

output "prod_cb_project_names" {
  description = "Names of all codebuild projects"
  value       = module.prod_pipeline.codebuild_project_names
}

output "prod_cb_service_role_arn" {
  description = "Codebuild project service role arn"
  value       = module.prod_pipeline.codebuild_project_service_role_arn
}

output "prod_cp_arn" {
  description = "codepipeline ARN"
  value       = module.prod_pipeline.codepipeline_arn
}

output "prod_cp_service_role_arn" {
  description = "Codepipeline service role arn"
  value       = module.prod_pipeline.codepipeline_service_role_arn
}
 */


################################################################################
# PROD ACT IAM ROLE OUTPUTS
################################################################################

/* output "prod_cross_act_role_arn" {
  description = "Arn of cross account role in prod acct"
  value = module.prod_cross_act_role.cross_act_role_arn
} */