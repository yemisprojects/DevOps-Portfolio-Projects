variable "notification_rules_config" {
  description = "pipeline notification rule configuration"

  type = map(object({
    notification_rule_name = string
    pipeline_arn           = string
    event_type_ids         = list(string)
    detail_type            = string
  }))

  default = {
    rule_cp = {
      detail_type            = "BASIC"
      pipeline_arn           = null
      notification_rule_name = null
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

#Omit types for CFN input parameters
variable "configuration_name" {
  description = "The name of the configuration."
  default     = "cpipeline-status"
}

variable "guardrail_policies" {
  description = "The list of IAM policy ARNs that are applied as channel guardrails. The AWS managed 'AdministratorAccess' policy is applied as a default if this is not set."
  default     = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

variable "logging_level" {
  description = "Specifies the logging level for this configuration. This property affects the log entries pushed to Amazon CloudWatch Logs. Logging levels include ERROR, INFO, or NONE."
  default     = "ERROR"
}

variable "slack_channel_id" {
  description = "The ID of the Slack channel. To get the ID, open Slack, right click on the channel name in the left pane, then choose Copy Link. The channel ID is the 9-character string at the end of the URL. For example, ABCBBLZZZ."
}

variable "slack_workspace_id" {
  description = "The ID of the Slack workspace authorized with AWS Chatbot. To get the workspace ID, you must perform the initial authorization flow with Slack in the AWS Chatbot console. Then you can copy and paste the workspace ID from the console. For more details, see steps 1-4 in [Setting Up AWS Chatbot with Slack](https://docs.aws.amazon.com/chatbot/latest/adminguide/setting-up.html#Setup_intro) in the AWS Chatbot User Guide."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

/* variable "user_role_required" {
  type        = bool
  default     = false
  description = "Enables use of a user role requirement in your chat configuration."
}
 */

/* variable "sns_topic_arns" {
  description = "The ARNs of the SNS topics that deliver notifications to AWS Chatbot."
  type        = list(string)

} */

/* variable "iam_role_arn" {
  description = "The ARN of the IAM role that defines the permissions for AWS Chatbot. This is a user-defined role that AWS Chatbot will assume. This is not the service-linked role. For more information, see [IAM Policies for AWS Chatbot](https://docs.aws.amazon.com/chatbot/latest/adminguide/chatbot-iam-policies.html)."
}
 */