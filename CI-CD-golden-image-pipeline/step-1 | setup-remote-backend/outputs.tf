################################################################################
# OUTPUTS pipeline_backend
################################################################################
output "pipeline_s3_bucket_id" {
  description = "Name of the bucket for S3 backend (ami-pipeline)"
  value       = module.pipeline_backend.s3_bucket_id
}

output "pipeline_table_id" {
  description = "Name of dynamodb table for remote state (ami-pipeline)"
  value       = module.pipeline_backend.table_id
}

################################################################################
# OUTPUTS main_backend
################################################################################
output "main_s3_bucket_id" {
  description = "Name of the bucket for S3 backend (ami-pipeline)"
  value       = module.main_backend.s3_bucket_id
}

output "main_table_id" {
  description = "Name of dynamodb table for remote state (ami-pipeline)"
  value       = module.main_backend.table_id
}