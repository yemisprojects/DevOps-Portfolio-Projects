output "s3_bucket_id" {
  description = "Name of the bucket for S3 backend"
  value       = aws_s3_bucket.this.id
}

output "s3_bucket_arn" {
  description = "ARN of the bucket for S3 backend"
  value       = aws_s3_bucket.this.arn
}

output "table_id" {
  description = "Name of dynamodb table for remote state"
  value       = aws_dynamodb_table.this.id
}

output "table_arn" {
  description = "Arn of dynamodb table for remote state"
  value       = aws_dynamodb_table.this.arn
}

output "kms_key_arn" {
  description = "ARN of Customer KMS key for S3 bucket"
  value       = local.enable_sse_cmk ? aws_kms_key.this[0].arn : null
}

output "kms_key_id" {
  description = "Customer KMS Key Id for S3 bucket"
  value       = local.enable_sse_cmk ? aws_kms_key.this[0].id : null
}

output "managed_kms_key_id" {
  description = "AWS Managed KMS Key Id for S3 bucket"
  value       = (var.s3_sse_algorithm == "aws:kms") && !var.create_cmk_sse_kms ? data.aws_kms_key.s3_kms_alias[0].id : null
}

output "managed_kms_key_arn" {
  description = "AWS Managed KMS Key ARN for S3 bucket"
  value       = (var.s3_sse_algorithm == "aws:kms") && !var.create_cmk_sse_kms ? data.aws_kms_key.s3_kms_alias[0].arn : null
}


