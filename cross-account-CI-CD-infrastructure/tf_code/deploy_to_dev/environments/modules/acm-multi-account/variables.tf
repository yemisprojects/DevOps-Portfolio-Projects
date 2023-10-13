################################################################################
# VARIABLES
################################################################################
variable "r53_zone_name" {
  description = "route53 hosted zone name"
  type = string
}

variable "acm_domain_name" {
  type = string
  default = "prod.devopscloudemos.tk"
}

variable "acm_subject_alternate_names" {
  type = list(string)
  default = null
}

variable "validation_timeout" {
  description = "Define maximum timeout to wait for the validation to complete"
  type        = string
  default     = "75m"
}
