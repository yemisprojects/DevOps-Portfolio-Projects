################################################################################
# WAF WEB ACL
################################################################################
resource "aws_wafv2_web_acl" "this" {
  name        = var.web_acl_name
  scope       = "REGIONAL"
  description = "Demo WebACL with managed and custom rules"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = var.web_acl_name
    sampled_requests_enabled   = true
  }

  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 60

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSet-metric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 20

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAmazonIpReputationList-metric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAnonymousIpList"
    priority = 30

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAnonymousIpList-metric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 40

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesSQLiRuleSet-metric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 10

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet-metric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "WAFBlacklistRule1"
    priority = 1

    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.blacklist_alb_ipv4.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "MetricForBlacklistRule"
      sampled_requests_enabled   = true
    }

  }

  rule {
    name     = "HttpFloodRateBasedRule"
    priority = 2

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = var.rate_limit_threshold
        aggregate_key_type = "IP"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSRateBasedRuleDomesticDOS"
      sampled_requests_enabled   = true
    }
  }

  tags = var.web_acl_tags

}

################################################################################
# WAF-ALB
################################################################################
resource "aws_wafv2_web_acl_association" "this" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}

################################################################################
# WAF BLACKLIST IP SET
################################################################################
resource "aws_wafv2_ip_set" "blacklist_alb_ipv4" {
  name               = var.ip_set_blacklist_name
  description        = "IP addresses to block"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.ipv4_blacklist_addresses

  tags = var.ip_set_tags
}

################################################################################
# WAF LOGGING
################################################################################
resource "aws_wafv2_web_acl_logging_configuration" "this" {
  log_destination_configs = var.waf_log_choice == "cloudwatch" ? [aws_cloudwatch_log_group.waf_logs[0].arn] : [aws_s3_bucket.waf_logs[0].arn]
  resource_arn            = aws_wafv2_web_acl.this.arn
}

resource "aws_cloudwatch_log_group" "waf_logs" {
  count = var.waf_log_choice == "cloudwatch" ? 1 : 0
  name = "aws-waf-logs-${random_pet.this.id}"
  tags = var.cloud_watch_tags
}

resource "aws_s3_bucket" "waf_logs" {
  count = var.waf_log_choice == "s3" ? 1 : 0
  bucket        = "aws-waf-logs-${random_pet.this.id}"
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "waf_logs" {
  count = var.waf_log_choice == "s3" ? 1 : 0
  bucket = aws_s3_bucket.waf_logs[0].bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "waf_logs" {
  count = var.waf_log_choice == "s3" ? 1 : 0
  bucket                  = aws_s3_bucket.waf_logs[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "random_pet" "this" {
}
