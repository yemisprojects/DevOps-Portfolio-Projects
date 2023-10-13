################################################################################
# GENERAL
################################################################################
variable "pipeline_type" {
  description = "Purpose of pipeline"
  type        = string
  default     = "ami-pipeline"

  validation {
    condition     = contains(["nonprod-infra", "prod-infra", "ami-pipeline"], var.pipeline_type)
    error_message = "Valid values for pipeline_type are: nonprod-infra, prod-infra, ami-pipeline"
  }
}

variable "s3_bucket_force_destroy" {
  description = "Forcefully destroy all S3 pipeline and codebuild buckets without error"
  type        = bool
  default     = true #FOR DEMO PURPOSE ONLY
}

variable "git_tag_trigger" {
  description = "git tag suffix used to start the pipeline"
  type        = string
  default     = null
}

################################################################################
# CODE-COMMIT
################################################################################
variable "repo_name" {
  description = "Name for the repository"
  type        = string
  default     = "infra-repo"
}

variable "repo_description" {
  description = "Purpose of repo"
  type        = string
  default     = "Repo for app or infra code"
}

variable "repo_tags" {
  description = "Tags to associate to repo"
  type        = map(string)
  default     = {}
}

variable "branch_name" {
  description = "Name of the branch where source changes are to be detected"
  type        = string
  default     = "main"
}

################################################################################
# EVENT-BRIDGE
################################################################################
variable "event_bridge_rule_tags" {
  description = "Tags to assign to eventbridge rule"
  type        = map(string)
  default     = {}
}

################################################################################
# CODEPIPELINE
################################################################################
variable "codepipeline_name" {
  description = "Name of the pipeline"
  type        = string
  default     = "Demo-Infra-Pipeline"
}

variable "codepipeline_tags" {
  description = "Tags to assign to CodePipeline"
  type        = map(string)
  default     = {}
}

variable "codepipeline_bucket_tags" {
  description = "Tags to assign to codepipeline artifact bucket"
  type        = map(string)
  default     = {}
}

variable "deploy_stage_name" {
  description = "Name of deploy stage (last stage in the pipeline)"
  type        = string
  default     = "Deploy"
}

################################################################################
# CODEBUILD
################################################################################
variable "cb_image" {
  description = "codebuild environment image"
  type        = string
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
}

variable "cb_project_configs" {
  description = "Configuration for each codebuild project"
  type        = map(object( { 
                              project_name = string
                              buildspec_path = string
                            }
                          )
                    )
  default = {
    "sample_project" = {
                          project_name   = "project-x"
                          buildspec_path = "buildspecs/x.yml"
                        }
  }
}

variable "codebuild_bucket_tags" {
  description = "Tags to assign to codebuild log bucket"
  type        = map(string)
  default     = {}
}

variable "codebuild_tags" {
  description = "Tags to assign to all codebuild projects"
  type        = map(string)
  default     = {}
}

################################################################################
# KMS
################################################################################
variable "kms_key_alias" {
  description = "Alias of S3 Kms key"
  type        = string
  default     = "alias/demo-pipeline"
}

variable "deletion_window_days" {
  description = "Waiting period after which to delete kms key"
  type        = number
  default     = 7
}

variable "enable_key_rotation" {
  description = "Enable key rotation"
  type        = bool
  default     = true
}

variable "kms_key_tags" {
  description = "Tags to assign to kms key"
  type        = map(string)
  default     = {}
}

################################################################################
# NOTIFICATIONs
################################################################################
variable "pipeline_status_sns_topic" {
  description = "Name of sns topic to publish for Pipeline status"
  type        = string
  default     = "pipeline-status"
}

variable "codepipeline_approval_sns_topic" {
  description = "Name of sns topic to use for manual approval in Pipeline"
  type        = string
  default     = "pipeline-approval"
}

variable "pipeline_approval_email_id" {
  description = "Eamil id for manual approval"
  type        = string
  default     = null
}

variable "create_sns_notification_rule" {
  description = "Create rule for pipeline status notifications using SNS"
  type        = bool
  default     = false
}

variable "pipeline_status_email_id" {
  description = "Eamil id for pipeline status notifications"
  type        = string
  default     = null
}

