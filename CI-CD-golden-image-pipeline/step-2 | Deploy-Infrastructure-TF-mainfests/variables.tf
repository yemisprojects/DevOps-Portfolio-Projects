variable "aws_region" {
  description = "Region to deploy resources"
  type        = string
  default     = "us-east-1"
}

################################################################################
# VARIABLES - golden_ami_pipeline
################################################################################
variable "ami_repo_name" {
  description = "Name for the repository"
  type        = string
  default     = "golden-ami-repo"
}

variable "ami_deploy_stage_name" {
  description = "Name of deploy stage"
  type        = string
  default     = "Share-AMI"
}

variable "ami_codepipeline_name" {
  description = "Name of the pipeline"
  type        = string
  default     = "golden-ami-pipeline"
}

variable "pipeline_approval_email_id" {
  description = "Eamil id for manual approval"
  type        = string
}

################################################################################
# VARIABLES - inspector_ec2_instance
################################################################################
variable "scan_duration" {
  description = "The duration in secs of the inspector run"
  type        = string
  default     = "300"
}

variable "inspector_email_id" {
  description = "Eamil id for inspector assessment run notifications"
  type        = string
}

################################################################################
# VARIABLES - slack_notification
################################################################################
variable "slack_channel_id" {
  description = "The ID of the Slack channel. To get the ID, open Slack, right click on the channel name in the left pane, then choose Copy Link. The channel ID is the 9-character string at the end of the URL. For example, ABCBBLZZZ."
  type        = string
}

variable "slack_workspace_id" {
  description = "The ID of the Slack workspace authorized with AWS Chatbot. To get the workspace ID, you must perform the initial authorization flow with Slack in the AWS Chatbot console. Then you can copy and paste the workspace ID from the console. For more details, see steps 1-4 in [Setting Up AWS Chatbot with Slack](https://docs.aws.amazon.com/chatbot/latest/adminguide/setting-up.html#Setup_intro) in the AWS Chatbot User Guide."
  type        = string
}

variable "event_type_ids" {
  description = "List of pipeline events to recieve notification on"
  type        = list(string)
  default = [
    "codepipeline-pipeline-pipeline-execution-started",
    "codepipeline-pipeline-pipeline-execution-failed",
    "codepipeline-pipeline-pipeline-execution-canceled",
    "codepipeline-pipeline-pipeline-execution-succeeded",
    "codepipeline-pipeline-manual-approval-needed",
    "codepipeline-pipeline-manual-approval-succeeded",
    "codepipeline-pipeline-manual-approval-failed"
  ]
}
