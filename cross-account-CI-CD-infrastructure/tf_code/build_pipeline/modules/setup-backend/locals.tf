/*locals {
  enable_sse_cmk         = var.s3_sse_algorithm == "aws:kms" && var.create_cmk_sse_kms
  use_sse_cmk            = local.enable_sse_cmk ? aws_kms_key.this[0].arn : null
  use_s3_managed_kms_key = var.s3_sse_algorithm == "aws:kms" && (!var.create_cmk_sse_kms) ? data.aws_kms_key.s3_kms_alias[0].arn : local.use_sse_cmk
}*/