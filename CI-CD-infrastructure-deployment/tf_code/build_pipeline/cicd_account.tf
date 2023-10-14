################################################################################
# SETUP BACKEND For DEV ENVIRONMENT in TOOLING ACCOUNT
################################################################################
/* create dynamoDb and S3 bucket for storing remote state of dev infrastructure */
module "dev_backend" {
  source = "./modules/setup-backend"

  providers = {
    aws = aws.cicd_act
  }

  table_name  = "dev-tfstate-lock"
  bucket_name = "dev-tfstate-${random_integer.this.id}"
}

resource "random_integer" "this" {
  min = 100000000000
  max = 999999999999
}

################################################################################
# CREATE PIPELINE FOR DEV ENV AND TRIGGER WITH GIT TAGS
################################################################################
module "dev_pipeline" {
  source = "./modules/setup-pipeline"

  providers = {
    aws = aws.cicd_act
  }

  pipeline_type     = "nonprod-infra"
  repo_name         = var.dev_repo_name
  deploy_stage_name = var.dev_deploy_stage_name
  codepipeline_name = var.dev_codepipeline_name
  pipeline_approval_email_id = var.pipeline_approval_email_id
  cb_image          = "${aws_ecr_repository.cb_image.repository_url}:latest"

  cb_project_configs = {
    "infracost" = {
      project_name   = "infracost_dev"
      buildspec_path = "buildspecs/buildspec-infracost.yml"
    },
    "tflint" = {
      project_name   = "tflint_dev"
      buildspec_path = "buildspecs/buildspec-tflint.yml"
    },
    "checkov" = {
      project_name   = "checkov_dev"
      buildspec_path = "buildspecs/buildspec-checkov.yml"
    },
    "terrascan" = {
      project_name   = "terrascan_dev"
      buildspec_path = "buildspecs/buildspec-terrascan.yml"
    },
    "tfplan" = {
      project_name   = "tfplan_dev"
      buildspec_path = "buildspecs/buildspec-plan.yml"
    },
    "tfapply" = {
      project_name   = "tfapply_dev"
      buildspec_path = "buildspecs/buildspec-apply.yml"
    }
  }
}

################################################################################
# IMAGE USED BY CODEPIPELINE/CODEBUILD PROJECTS 
################################################################################
resource "aws_ecr_repository" "cb_image" {

  provider = aws.cicd_act

  name                 = var.cb_ecr_repo
  image_tag_mutability = "MUTABLE"
  force_delete         = true #demo purpose only

  image_scanning_configuration {
    scan_on_push = false #demo purpose only
  }
  tags = var.tags

}

resource "null_resource" "create_ecr_image" {
  depends_on = [aws_ecr_repository.cb_image]

/* requires docker installed and running*/
  provisioner "local-exec" {
    when    = create
    command = "chmod +x script/push_image_v2.sh && bash script/push_image_v2.sh ${aws_ecr_repository.cb_image.repository_url} ${var.cicd_act_profile} ${var.aws_region}"
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "docker image prune -a"
    on_failure = fail
  }

}

################################################################################
# STORE INFRACOST API KEY FOR USE BY PIPELINE
################################################################################
resource "aws_secretsmanager_secret" "infracost" {
  provider = aws.cicd_act

  name_prefix = "infracost_api_key"
}

resource "aws_secretsmanager_secret_version" "infracost" {
  provider = aws.cicd_act

  secret_id     = aws_secretsmanager_secret.infracost.id
  secret_string = <<EOF
   {
    "api_key": "${var.api_key}"
   }
EOF
  depends_on = [
    aws_s3_bucket.infracost
  ]
}

################################################################################
# AWS_CHATBOT FOR PIPELINE NOTIFICATIONS TO SLACK
################################################################################
/*Create slack workspace and private channel (devops-team). Create a Chatbot slack client */
/* Configuration channel will be created by the module */
module "slack_notification" {
  source = "./modules/pipeline-chatbot-slack"

  providers = {
    aws = aws.cicd_act
  }

  configuration_name = "codepipeline-status"
  slack_channel_id   = var.slack_channel_id
  slack_workspace_id = var.slack_workspace_id

  notification_rules_config = {
    ami_cp = {
      detail_type            = "BASIC"
      notification_rule_name = "pipeline-slack"
      pipeline_arn           = module.dev_pipeline.codepipeline_arn
      event_type_ids = [
        "codepipeline-pipeline-pipeline-execution-started",
        "codepipeline-pipeline-pipeline-execution-failed",
        "codepipeline-pipeline-pipeline-execution-canceled",
        "codepipeline-pipeline-pipeline-execution-succeeded",
        "codepipeline-pipeline-manual-approval-needed",
        "codepipeline-pipeline-manual-approval-succeeded",
        "codepipeline-pipeline-manual-approval-failed"
      ]
    }

  }
}

################################################################################
# USED IN PIPELINE TO SEND SES COST REPORTS EMAIL
################################################################################
resource "aws_ses_email_identity" "email_infracost" {
  provider = aws.cicd_act

  email = var.email_infracost_reports
}

resource "aws_ssm_parameter" "email_infracost" {
  provider = aws.cicd_act

  name  = "/infracost/cost-usage-report/email-contact"
  type  = "String"
  value = var.email_infracost_reports
}

################################################################################
# BACKUP COST REPORTS to S3 FROM PIPELINE
################################################################################
# S3 LOCATTION FOR INFRACOST COST REPORTS
resource "aws_ssm_parameter" "infracost" {
  provider = aws.cicd_act

  name  = "/infracost/cost-usage-report/bucket"
  type  = "String"
  value = aws_s3_bucket.infracost.id
}

resource "aws_s3_bucket" "infracost" {
  provider      = aws.cicd_act
  force_destroy = true #demo purpose only
}

resource "aws_s3_bucket_public_access_block" "infracost" {
  provider = aws.cicd_act

  bucket                  = aws_s3_bucket.infracost.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "infracost" {
  provider = aws.cicd_act

  bucket = aws_s3_bucket.infracost.id
  versioning_configuration {
    status = "Enabled"
  }
}

/*resource "aws_s3_bucket_server_side_encryption_configuration" "infracost" {
  provider = aws.cicd_act

  bucket = aws_s3_bucket.infracost.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}*/











/*################################################################################
# CREATE  AND TRIGGER WITH GIT TAGS
################################################################################
module "prod_pipeline" {
  source = "./modules/setup-pipeline"

  providers = {
    aws = aws.cicd_act
  }

  pipeline_type              = "prod-infra"
  git_tag_trigger            = "-prod"
  repo_name                  = var.prod_repo_name
  deploy_stage_name          = var.prod_deploy_stage_name
  codepipeline_name          = var.prod_codepipeline_name
  pipeline_approval_email_id = var.pipeline_approval_email_id
  cb_image                   = "${aws_ecr_repository.cb_image.repository_url}:latest"

  cb_project_configs = {
    "infracost" = {
      project_name   = "infracost_prod"
      buildspec_path = "buildspecs/prod/buildspec-infracost.yml"
    }
    "tflint" = {
      project_name   = "tflint_prod"
      buildspec_path = "buildspecs/prod/buildspec-tflint.yml"
    },
    "checkov" = {
      project_name   = "checkov_prod"
      buildspec_path = "buildspecs/prod/buildspec-checkov.yml"
    },
    "terrascan" = {
      project_name   = "terrascan_prod"
      buildspec_path = "buildspecs/prod/buildspec-terrascan.yml"
    },
    "tfplan" = {
      project_name   = "tfplan_prod"
      buildspec_path = "buildspecs/prod/buildspec-plan.yml"
    },
    "tfapply" = {
      project_name   = "tfapply_prod"
      buildspec_path = "buildspecs/prod/buildspec-apply.yml"
    }
  }
}
*/