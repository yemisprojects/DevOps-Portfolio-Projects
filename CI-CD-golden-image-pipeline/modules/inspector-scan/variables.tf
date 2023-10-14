variable "template_name" {
  description = "The name of the assessment template"
  type        = string
  default     = "Scan-golden-ami-instances"
}

variable "target" {
  description = "The name of the assessment target"
  type        = string
  default     = "target-golden-amis"
}

variable "duration" {
  description = "The duration in secs of the inspector run"
  type        = string
  default     = "900" #"3600"
}

variable "target_resource_tags" {
  description = "Key-value map of tags that are used to select the EC2 instances"
  type        = map(any)
  default     = { AwsInspectorScan = "True" }
}

variable "inspector_email_id" {
  description = "Email to receive notification events"
  type        = string
}

variable "sns_topic_name" {
  description = "SNS topic for Inspector notification events"
  type        = string
  default     = "aws-inspector-alerts"
}

variable "account_id" {
  description = "AccountID to apply to sns topic access policy"
  type        = string

}

variable "rules_package_arns" {
  type = list(string)
  default = [
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-R01qwB5Q",
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-gEjTy7T7",
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-rExsr2X8"
  ]
}