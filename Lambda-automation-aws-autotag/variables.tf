############ Input variable definitions ############
variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-west-1"
}

variable "create_trail" {
  description = "Set to false if a Cloudtrail trail for management events exists"
  type        = bool
  default     = true
}

variable "autotag_function_name" {
  description = "Name of lambda function"
  type        = string
  default     = "autotag"
}

variable "lambda_log_level" {
  description = "Lambda logging level"
  type        = string
  default     = "INFO"
}
