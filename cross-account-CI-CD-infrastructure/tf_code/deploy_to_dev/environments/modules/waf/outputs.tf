output "ipset_blacklist_arn" {
  description = "The ARN of the IP set used to blacklist IPs"
  value       = aws_wafv2_ip_set.blacklist_alb_ipv4.arn
}

output "waf_log_bucket" {
  description = "The ARN of the bucket used to store WAF logs"
  value       = var.waf_log_choice == "s3" ? aws_s3_bucket.waf_logs[0].arn : null
}

output "cloudwatch_log_grp_waf_logs" {
  description = "The ARN of the cloudwatch log group for store WAF logs"
  value       = var.waf_log_choice == "cloudwatch" ? aws_cloudwatch_log_group.waf_logs[0].arn : null
}

output "web_acl_arn" {
  description = "The ARN of the WAF WebACL"
  value       = aws_wafv2_web_acl.this.arn
}

output "web_acl_capacity" {
  description = " Web ACL capacity units (WCUs) used by this web ACL"
  value       = aws_wafv2_web_acl.this.capacity
}
