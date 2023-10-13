################################################################################
# DYNAMO
################################################################################
variable "table_name" {
  description = "Name of dynamodb table"
  type        = string
}

variable "table_tags" {
  description = "Tags to add to dynamodb table"
  type        = map(string)
  default     = {}
}

################################################################################
# S3
################################################################################
variable "bucket_name" {
  description = "Name of S3 bucket"
  type        = string
}

variable "force_destroy" {
  description = "Delete all objects from the bucket without error"
  type        = bool
  default     = true #SET TO FALSE IN PROD!!
}

variable "bucket_tags" {
  description = "Tags to assign to bucket"
  type        = map(string)
  default     = {}
}














/*
variable "s3_sse_algorithm" {
  description = "S3 Server-side encryption algorithm to use"
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.s3_sse_algorithm)
    error_message = "The bucket encryption algorithm must be AES256 or aws:kms"
  }
}

variable "create_cmk_sse_kms" {
  description = "Create a customer managed key for SSE-KMS instead of default AWS managed kms key(aws/s3)"
  type        = bool
  default     = false
}*/

################################################################################
# KMS
################################################################################
/*variable "kms_key_alias" {
  description = "Alias of S3 Kms key"
  type        = string
  default     = "alias/s3-backend"
}

variable "enable_key_rotation" {
  description = "Enable key rotation"
  type        = bool
  default     = true
}

variable "deletion_window_days" {
  description = "Waiting period after which to delete kms key"
  type        = number
  default     = 7
}

variable "kms_key_tags" {
  description = "Tags to assign to KMS Key"
  type        = map(string)
  default     = {}
}*/
