############ Input variable definitions ############
variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default = "us-west-1"
}

variable "sender_email_address" {
  description = "Email used to send compliance messages if no resource tag email exists"
  type        = string
}

variable "sns_email_address" {
  description = "Email used to receive automation failure"
  type        = string
}

variable "lambda_evaluator_name" {
  description = "Name of lambda function"
  type        = string
  default     = "sqs-compliance-evaluator"
}

variable "lambda_mailer_name" {
  description = "Name of lambda function"
  type        = string
  default     = "send-compliance-notification"
}