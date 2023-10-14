data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
################################################################################
# DynamoDB TF state Lock
################################################################################
resource "aws_dynamodb_table" "this" {

  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.table_tags
}

################################################################################
# S3 Backend
################################################################################
resource "aws_s3_bucket" "this" {

  bucket        = var.bucket_name
  force_destroy = var.force_destroy
  tags          = var.bucket_tags
}

resource "aws_s3_bucket_public_access_block" "this" {

  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "this" {

  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "this" {

  bucket = aws_s3_bucket.this.id
  policy = templatefile("${path.module}/templates/s3_bucket_policy.tftpl", { bucket_name = var.bucket_name })
}
















/*resource "aws_s3_bucket_server_side_encryption_configuration" "this" {

  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = local.use_s3_managed_kms_key #local.enable_sse_cmk ? aws_kms_key.this[0].arn : null
      sse_algorithm     = var.s3_sse_algorithm
    }
  }

}*/

################################################################################
# S3 KMS key 
################################################################################
/*data "aws_kms_key" "s3_kms_alias" {
  count  = (var.s3_sse_algorithm == "aws:kms") && !var.create_cmk_sse_kms ? 1 : 0
  key_id = "alias/aws/s3"
}

resource "aws_kms_key" "this" {
  count = local.enable_sse_cmk ? 1 : 0

  description             = "key to encrypt S3 bucket"
  deletion_window_in_days = var.deletion_window_days
  enable_key_rotation     = var.enable_key_rotation
  policy = templatefile(  "${path.module}/templates/kms_key_policy.tftpl",
                          { account_id = data.aws_caller_identity.current.account_id
                            region     = data.aws_region.current.name
                          }
                      )

  tags = var.kms_key_tags
}

resource "aws_kms_alias" "this" {
  count = local.enable_sse_cmk ? 1 : 0

  name          = var.kms_key_alias
  target_key_id = aws_kms_key.this[0].key_id
}*/
