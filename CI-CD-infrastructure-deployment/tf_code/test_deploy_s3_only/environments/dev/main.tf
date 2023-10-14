resource "aws_s3_bucket" "this" {}

#FIX SEC ISSUES or skip rules
/*resource "aws_s3_bucket_public_access_block" "this" {

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
} */

/*resource "aws_s3_bucket_server_side_encryption_configuration" "this" {

  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = local.use_s3_managed_kms_key #local.enable_sse_cmk ? aws_kms_key.this[0].arn : null
      sse_algorithm     = var.s3_sse_algorithm
    }
  }

}*/
