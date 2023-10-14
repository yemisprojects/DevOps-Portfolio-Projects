
################################################################################
# NON-PROD INFRASTRUCTURE PIPELINE
################################################################################
resource "aws_codepipeline" "non_prod_infra" {
  count = var.pipeline_type == "nonprod-infra" ? 1 : 0

  name     = var.codepipeline_name
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_artifact_store.id
    type     = "S3"
  
    encryption_key {
      id   = aws_kms_key.this.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["SOURCE_ARTIFACT"]

      configuration = {
        RepositoryName       = var.repo_name
        BranchName           = var.branch_name
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "Validation"

    action {
      name            = "tf_lint"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["SOURCE_ARTIFACT"]
      version         = "1"
      run_order       = 1

      configuration = {
        ProjectName = aws_codebuild_project.this["tflint"].name
      }
    }

    action {
      name            = "checkov"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["SOURCE_ARTIFACT"]
      version         = "1"
      run_order       = 1

      configuration = {
        ProjectName = aws_codebuild_project.this["checkov"].name
      }
    }

    action {
      name            = "terrascan"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["SOURCE_ARTIFACT"]
      version         = "1"
      run_order       = 1

      configuration = {
        ProjectName = aws_codebuild_project.this["terrascan"].name
      }
    }
  }

  stage {
    name = "Cost-Estimation"

    action {
      name            = "Infracost"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["SOURCE_ARTIFACT"]
      output_artifacts = ["INFRA_COST_ARTIFACT"]
      version         = "1"
      run_order       = 1

      configuration = {
        ProjectName = aws_codebuild_project.this["infracost"].name
      }
    }
  }

  stage {
    name = "Plan"

    action {
      name            = "Terraform-Plan"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["INFRA_COST_ARTIFACT"]
      output_artifacts = ["TF_PLAN_ARTIFACT"]
      version         = "1"
      run_order       = 1

      configuration = {
        ProjectName = aws_codebuild_project.this["tfplan"].name
      }
    }
  }

  stage {
    name = "Manual-Appproval"

    action {
      name     = "Tech-Lead"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"

      configuration = {
        NotificationArn = aws_sns_topic.pipeline_approval[0].arn
        CustomData      = "Please review terraform plan before deployment"
      }
    }
  }

  stage {
    name = var.deploy_stage_name

    action {
      name            = "Terraform-Apply"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["TF_PLAN_ARTIFACT"]
      version         = "1"
      run_order       = 1

      configuration = {
        ProjectName = aws_codebuild_project.this["tfapply"].name
      }
    }
  }

  tags = var.codepipeline_tags
}

###############################################################################
# PROD INFRASTRUCTURE PIPELINE
###############################################################################
resource "aws_codepipeline" "prod_infra_pipeline" {
  count = var.pipeline_type == "prod-infra" ? 1 : 0

  name     = var.codepipeline_name
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_artifact_store.id
    type     = "S3"
  
    encryption_key {
      id   = aws_kms_key.this.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        RepositoryName       = var.repo_name
        BranchName           = var.branch_name
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "Cost-Estimation"

    action {
      name            = "Infracost"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source"]
      version         = "1"
      run_order       = 1

      configuration = {
        ProjectName = aws_codebuild_project.this["infracost"].name
      }
    }
  }

  stage {
    name = "Lint_SecurityCheck"

    action {
      name            = "tf_lint"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source"]
      version         = "1"
      run_order       = 2

      configuration = {
        ProjectName = aws_codebuild_project.this["tflint"].name
      }
    }

    action {
      name            = "checkov"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source"]
      version         = "1"
      run_order       = 3

      configuration = {
        ProjectName = aws_codebuild_project.this["checkov"].name
      }
    }

    action {
      name            = "terrascan"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source"]
      version         = "1"
      run_order       = 1

      configuration = {
        ProjectName = aws_codebuild_project.this["terrascan"].name
      }
    }
  }

  stage {
    name = "Plan"

    action {
      name            = "Terraform-Plan"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source"]
      version         = "1"
      run_order       = 1

      configuration = {
        ProjectName = aws_codebuild_project.this["tfplan"].name
      }
    }
  }

  stage {
    name = "Manual-Appproval"

    action {
      name     = "Tech-Lead"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"

      configuration = {
        NotificationArn = aws_sns_topic.pipeline_approval[0].arn
        CustomData      = "Please review terraform plan before deployment"
      }
    }
  }

  stage {
    name = var.deploy_stage_name

    action {
      name            = "Terraform-Apply"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source"]
      version         = "1"
      run_order       = 1

      configuration = {
        ProjectName = aws_codebuild_project.this["tfapply"].name
      }
    }
  }

  tags = var.codepipeline_tags
}


################################################################################
# GOLDEN-AMI PIPELINE
################################################################################
resource "aws_codepipeline" "golden_ami" {
  count = var.pipeline_type == "ami-pipeline" ? 1 : 0

  name     = var.codepipeline_name
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_artifact_store.id
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        RepositoryName       = var.repo_name
        BranchName           = var.branch_name
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "Create-AMI"

    action {
      name             = "Packer_ami_build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source"]
      output_artifacts = ["goldenami_output"]
      version          = "1"
      run_order        = 1
      namespace        = "ami_manifest"

      configuration = {
        ProjectName = aws_codebuild_project.this["create_ami"].name
      }
    }
  }

  stage {
    name = "Vulnerability-Scan"

    action {
      name            = "AWS_inspector"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["goldenami_output"]
      version         = "1"
      run_order       = 1

      configuration = {
        ProjectName = aws_codebuild_project.this["scan_ami"].name
      }
    }

  }

  stage {
    name = "Manual-Appproval"

    action {
      name     = "Vulnerability_scan_review"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"

      configuration = {
        NotificationArn = aws_sns_topic.pipeline_approval[0].arn
        CustomData      = "Please review the AWS Inspector findings report you received before approving abd Sharing AMI to child AWS accounts"
      }
    }
  }

  stage {
    name = var.deploy_stage_name

    action {
      name            = "Share_AMI"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["goldenami_output"]
      version         = "1"
      run_order       = 1

      configuration = {
        ProjectName = aws_codebuild_project.this["share_ami"].name
      }
    }
  }

  tags = var.codepipeline_tags
}

################################################################################
# INFRA CODEPIPELINE SERVICE ROLE
################################################################################
resource "aws_iam_role" "codepipeline" {
  name = "codepipeline-${var.pipeline_type}-${local.codepipeline_id}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

#refine * to stricter permissions
resource "aws_iam_role_policy" "codepipeline" {
  name = "pipeline-policy"
  role = aws_iam_role.codepipeline.id
  policy = templatefile("${path.module}/templates/codepipeline_policy.tftpl",
    {
      codebuild_project_arns = jsonencode([for p in aws_codebuild_project.this : "${p.arn}"])
    }
  )

}

################################################################################
# CODEPIPELINE ARTIFACT STORE
################################################################################
resource "aws_s3_bucket" "codepipeline_artifact_store" {
  bucket        = "codepipeline-artifacts-${local.codepipeline_id}" #var.codepipeline_bucket_name
  force_destroy = var.s3_bucket_force_destroy
  tags          = var.codepipeline_bucket_tags
}

resource "aws_s3_bucket_public_access_block" "codepipeline_artifact_store" {
  bucket = aws_s3_bucket.codepipeline_artifact_store.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "codepipeline_artifact_store" {
  bucket = aws_s3_bucket.codepipeline_artifact_store.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "codepipeline_artifact_store" {
  bucket = aws_s3_bucket.codepipeline_artifact_store.id
  policy = templatefile("${path.module}/templates/s3_bucket_policy.tftpl",
    { bucket_name = aws_s3_bucket.codepipeline_artifact_store.id }
  )
}

resource "aws_s3_bucket_server_side_encryption_configuration" "codepipeline_artifact_store" {
  bucket = aws_s3_bucket.codepipeline_artifact_store.id

  rule {
    apply_server_side_encryption_by_default {
      # sse_algorithm = "AES256"
        kms_master_key_id = aws_kms_key.this.arn
        sse_algorithm     = "aws:kms"
    }
  }
}
