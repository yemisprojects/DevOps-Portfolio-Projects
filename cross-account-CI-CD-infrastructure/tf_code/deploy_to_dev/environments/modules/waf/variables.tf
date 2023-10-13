variable "alb_arn" {
  description = "ARN of the ALB resource to associate with the web ACL"
  type = string
}

variable "waf_log_choice" {
  description = "How to store WAF access logs. Select one of s3 or cloudwatch"
  type = string
  default = "s3"

  validation {
    condition     = contains(["s3", "cloudwatch"], var.waf_log_choice)
    error_message = "Invalid input, options: \"s3\",\"cloudwatch\"."
  }
}

variable "rate_limit_threshold" {
  description = "Limit on requests per 5-minute period for a single originating IP address"
  type        = number
  default     = 2000
}

variable "ip_set_tags" {
  description = "Tags to assocaiate with IP set"
  type        = map(string)
  default     = {}
}

variable "cloud_watch_tags" {
  description = "Tags to assocaiate with Cloudwatch log group"
  type        = map(string)
  default     = {}
}

variable "ip_set_blacklist_name" {
  description = "friendly name of the IP set"
  type        = string
  default     = "Blacklisted-IPs"
}

variable "ipv4_blacklist_addresses" {
  description = "IP addresses or blocks of IP addresses to blacklist"
  type        = list(string)
  default     = []
}

variable "web_acl_name" {
  description = "Friendly name of the WebACL"
  type        = string
  default     = "demo-web-acl"
}

variable "web_acl_tags" {
  description = "Map of key-value pairs to associate with the Web ACL"
  type        = map(string)
  default     = {}
}