################################################################################
# KMS KEY
################################################################################
resource "aws_kms_key" "this" {

  description             = "Encrypt codebuild S3 logs and codepipeline S3 artifcats"
  deletion_window_in_days = var.deletion_window_days
  enable_key_rotation     = var.enable_key_rotation
  policy = templatefile("${path.module}/templates/kms_key_policy.tftpl",
    { account_id         = local.account_id
      region             = local.region
      codebuild_role_arn = aws_iam_role.codebuild.arn
    }
  )

  tags = var.kms_key_tags
}

resource "aws_kms_alias" "this" {
  name          = "${var.kms_key_alias}-${random_id.this.id}"
  target_key_id = aws_kms_key.this.key_id
}

resource "random_id" "this" {
  byte_length = 1
}

