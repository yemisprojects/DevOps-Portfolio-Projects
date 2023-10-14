################################################################################
# CODE-COMMIT
################################################################################
output "repo_arn" {
  description = "ARN of repo"
  value       = aws_codecommit_repository.this.arn
}

output "clone_http_url" {
  description = "URL to use for cloning the repository over HTTPS"
  value       = aws_codecommit_repository.this.clone_url_http
}

output "clone_ssh_url" {
  description = "URL to use for cloning the repository over SSH."
  value       = aws_codecommit_repository.this.clone_url_ssh
}

################################################################################
# CODEBUILD
################################################################################
output "codebuild_project_names" {
  description = "Names of all codebuild projects"
  value       = [for cb in aws_codebuild_project.this : cb.name]
}

output "codebuild_project_arns" {
  description = "ARNs of all codebuild projects"
  value       = [for cb in aws_codebuild_project.this : cb.arn]
}

output "codebuild_project_service_role_arn" {
  description = "Codebuild project service role arn"
  value       = aws_iam_role.codebuild.arn
}

output "cb_log_bucket_arn" {
  description = "Codebuild Bucket for logging and caching"
  value       = aws_s3_bucket.cb_logs.arn
}

################################################################################
# CODEPIPELINE
################################################################################
output "codepipeline_arn" {
  description = "codepipeline ARN"
  value       = lookup(local.pipeline_arn, var.pipeline_type)
}

output "codepipeline_service_role_arn" {
  description = "Codepipeline service role arn"
  value       = aws_iam_role.codepipeline.arn
}

output "codepipeline_artifact_bucket_arn" {
  description = "ARN of Codepipeline artificat Bucket"
  value       = aws_s3_bucket.codepipeline_artifact_store.arn
}

output "pipeline_notification_rule_arn" {
  description = "The codestar notification rule ARN for pipeline status"
  value       = var.create_sns_notification_rule ? aws_codestarnotifications_notification_rule.pipeline_status[0].arn : null
}

################################################################################
# KMS 
################################################################################
output "kms_key_arn" {
  description = "Arn of kms key used by codebuild"
  value       = aws_kms_key.this.arn
}

output "kms_key_alias" {
  description = "Alias of kms key used by codebuild"
  value       = aws_kms_alias.this.name
}
