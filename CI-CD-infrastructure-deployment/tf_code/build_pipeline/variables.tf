################################################################################
# GENERAL VARIABLES
################################################################################
variable "aws_region" {
  description = "Region to deploy resources"
  type        = string
  default     = "us-east-1"
}

#use sts data source
variable "cicd_act_no" {
  description = "CI/CD tooling Account number"
  type        = string
}

variable "cicd_act_profile" {
  description = "Name of profile used for CICD account"
  type        = string
}

variable "dev_act_profile" {
  description = "Name of AWS profile used for dev account"
  type        = string
}

variable "pipeline_approval_email_id" {
  description = "Eamil id for manual approval"
  type        = string
}

################################################################################
# DEV ENV PIPELINE VARIABLES
################################################################################
variable "dev_repo_name" {
  description = "Name for the repository"
  type        = string
  default     = "dev-environment"
}

variable "dev_deploy_stage_name" {
  description = "Name of deploy stage"
  type        = string
  default     = "Deploy-dev"
}

variable "dev_codepipeline_name" {
  description = "Name of the pipeline"
  type        = string
  default     = "dev-infra-pipeline"
}

################################################################################
# CODEBUILD VARIABLES
################################################################################
variable "cb_ecr_repo" {
  description = "ECR repo name for codebuild environment"
  type        = string
  default     = "codebuild/custom-tf-tools"
}

variable "tags" {
  description = "Tags to assign to ecr repo"
  type        = map(string)
  default     = {}
}


################################################################################
# AWS_CHATBOT-SLACK VARIABLES
################################################################################
variable "slack_channel_id" {
  description = "The ID of the Slack channel. To get the ID, open Slack, right click on the channel name in the left pane, then choose Copy Link. The channel ID is the 9-character string at the end of the URL. For example, ABCBBLZZZ."
  type        = string
}

variable "slack_workspace_id" {
  description = "The ID of the Slack workspace authorized with AWS Chatbot. To get the workspace ID, you must perform the initial authorization flow with Slack in the AWS Chatbot console. Then you can copy and paste the workspace ID from the console. For more details, see steps 1-4 in [Setting Up AWS Chatbot with Slack](https://docs.aws.amazon.com/chatbot/latest/adminguide/setting-up.html#Setup_intro) in the AWS Chatbot User Guide."
  type        = string
}

################################################################################
# INFRACOST VARIABLES
################################################################################
variable "api_key" {
  description = "Infracost api key for cost estimates"
  type        = string
}

variable "email_infracost_reports" {
  description = "Email to send infracost email"
  type        = string
}





/* 
################################################################################
# PROD-PIPELINE VARIABLES
################################################################################
variable "prod_repo_name" {
  description = "Name for the repository"
  type        = string
  default     = "live-prod-infra-repo"
}

variable "prod_deploy_stage_name" {
  description = "Name of deploy stage"
  type        = string
  default     = "Deploy-prod"
}

variable "prod_codepipeline_name" {
  description = "Name of the pipeline"
  type        = string
  default     = "prod-infra-pipeline"
}
*/ 