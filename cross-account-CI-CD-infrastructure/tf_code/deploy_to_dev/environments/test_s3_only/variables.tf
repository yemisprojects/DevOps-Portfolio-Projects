variable "aws_region" {
  description = "Region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "cross_account_role" {
  type = string
}
