locals {
  image_pull_credentials_type = var.pipeline_type == "ami-pipeline" ? "CODEBUILD" : "SERVICE_ROLE"

  cb_policy = lookup({ "ami-pipeline" = "${path.module}/templates/codebuild_packer_policy.tftpl" },
  var.pipeline_type, "${path.module}/templates/codebuild_policy.tftpl")

  codebuild_id = random_integer.this["codebuild"].id
}

################################################################################
# CODEBUILD PROJECTS
################################################################################
resource "aws_codebuild_project" "this" {
  for_each = var.cb_project_configs

  name           = each.value.project_name
  description    = "Codebuild project for ${each.value.project_name}"
  service_role   = aws_iam_role.codebuild.arn
  encryption_key = aws_kms_key.this.arn
  build_timeout = "120"

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = var.cb_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = local.image_pull_credentials_type
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.cb_logs.id}/build-logs/${each.value.project_name}"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = each.value.buildspec_path
  }

  tags = var.codebuild_tags
}

################################################################################
# CODEBUILD LOGS
################################################################################
resource "aws_s3_bucket" "cb_logs" {
  bucket        = "codebuild-logs-${local.codebuild_id}" #var.codebuild_bucket_name
  force_destroy = var.s3_bucket_force_destroy
  tags          = var.codebuild_bucket_tags
}

resource "aws_s3_bucket_public_access_block" "codebuild" {
  bucket = aws_s3_bucket.cb_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "codebuild" {
  bucket = aws_s3_bucket.cb_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "codebuild" {
  bucket = aws_s3_bucket.cb_logs.id
  policy = templatefile("${path.module}/templates/s3_bucket_policy.tftpl",
    { bucket_name = aws_s3_bucket.cb_logs.id }
  )
}

resource "aws_s3_bucket_server_side_encryption_configuration" "codebuild" {
  bucket = aws_s3_bucket.cb_logs.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.this.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

################################################################################
# CODEBUILD SERVICE ROLE
################################################################################
resource "aws_iam_role" "codebuild" {
  name = "codebuild-${var.pipeline_type}-${local.codebuild_id}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

#refine * to stricter permissions
resource "aws_iam_role_policy" "codebuild" {
  name = "codebuild-policy"
  role = aws_iam_role.codebuild.id
  policy = templatefile(local.cb_policy,
    {
      account_id = local.account_id
      region     = local.region
    }
  )
}