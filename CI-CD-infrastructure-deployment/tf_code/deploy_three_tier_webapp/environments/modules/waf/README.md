<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.46 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.46 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.waf_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_s3_bucket.waf_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.waf_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.waf_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_wafv2_ip_set.blacklist_alb_ipv4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_web_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_logging_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration) | resource |
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_arn"></a> [alb\_arn](#input\_alb\_arn) | ARN of the ALB resource to associate with the web ACL | `string` | n/a | yes |
| <a name="input_cloud_watch_tags"></a> [cloud\_watch\_tags](#input\_cloud\_watch\_tags) | Tags to assocaiate with Cloudwatch log group | `map(string)` | `{}` | no |
| <a name="input_ip_set_blacklist_name"></a> [ip\_set\_blacklist\_name](#input\_ip\_set\_blacklist\_name) | friendly name of the IP set | `string` | `"Blacklisted-IPs"` | no |
| <a name="input_ip_set_tags"></a> [ip\_set\_tags](#input\_ip\_set\_tags) | Tags to assocaiate with IP set | `map(string)` | `{}` | no |
| <a name="input_ipv4_blacklist_addresses"></a> [ipv4\_blacklist\_addresses](#input\_ipv4\_blacklist\_addresses) | IP addresses or blocks of IP addresses to blacklist | `list(string)` | `[]` | no |
| <a name="input_rate_limit_threshold"></a> [rate\_limit\_threshold](#input\_rate\_limit\_threshold) | Limit on requests per 5-minute period for a single originating IP address | `number` | `2000` | no |
| <a name="input_waf_log_choice"></a> [waf\_log\_choice](#input\_waf\_log\_choice) | How to store WAF access logs. Select one of s3 or cloudwatch | `string` | `"s3"` | no |
| <a name="input_web_acl_name"></a> [web\_acl\_name](#input\_web\_acl\_name) | Friendly name of the WebACL | `string` | `"demo-web-acl"` | no |
| <a name="input_web_acl_tags"></a> [web\_acl\_tags](#input\_web\_acl\_tags) | Map of key-value pairs to associate with the Web ACL | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_log_grp_waf_logs"></a> [cloudwatch\_log\_grp\_waf\_logs](#output\_cloudwatch\_log\_grp\_waf\_logs) | The ARN of the cloudwatch log group for store WAF logs |
| <a name="output_ipset_blacklist_arn"></a> [ipset\_blacklist\_arn](#output\_ipset\_blacklist\_arn) | The ARN of the IP set used to blacklist IPs |
| <a name="output_waf_log_bucket"></a> [waf\_log\_bucket](#output\_waf\_log\_bucket) | The ARN of the bucket used to store WAF logs |
| <a name="output_web_acl_arn"></a> [web\_acl\_arn](#output\_web\_acl\_arn) | The ARN of the WAF WebACL |
| <a name="output_web_acl_capacity"></a> [web\_acl\_capacity](#output\_web\_acl\_capacity) | Web ACL capacity units (WCUs) used by this web ACL |
<!-- END_TF_DOCS -->