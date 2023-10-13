<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.46 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.46 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudwatch_cis_alarms"></a> [cloudwatch\_cis\_alarms](#module\_cloudwatch\_cis\_alarms) | terraform-aws-modules/cloudwatch/aws//modules/cis-alarms | 4.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_policy.high_cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_cloudwatch_log_group.cis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_metric_alarm.alb_4xx_errors](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.asg_high_cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.synthetics_canary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_iam_policy.cw_canary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.cw_canary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_s3_bucket.cw_canary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_sns_topic.cw_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.cw_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_synthetics_canary.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/synthetics_canary) | resource |
| [null_resource.lambda_code](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_pet.cis](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [random_pet.cw_canary](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [archive_file.lambda_code](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_iam_policy_document.assume_cw_canary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cw_canary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_4xx_errors_threshold"></a> [alb\_4xx\_errors\_threshold](#input\_alb\_4xx\_errors\_threshold) | ALB 4xx error threshold | `string` | `"5"` | no |
| <a name="input_app_fqdn"></a> [app\_fqdn](#input\_app\_fqdn) | app fqdn to be monitored by CW synthetics canary | `string` | n/a | yes |
| <a name="input_asg_high_cpu_threshold"></a> [asg\_high\_cpu\_threshold](#input\_asg\_high\_cpu\_threshold) | ASG high CPU threshold | `string` | `"80"` | no |
| <a name="input_asg_scaling_adjustment"></a> [asg\_scaling\_adjustment](#input\_asg\_scaling\_adjustment) | ASG policy scaling adjustment | `number` | `2` | no |
| <a name="input_autoscaling_group_name"></a> [autoscaling\_group\_name](#input\_autoscaling\_group\_name) | Name of the autoscaling group | `string` | n/a | yes |
| <a name="input_cw_sns_subscription_email"></a> [cw\_sns\_subscription\_email](#input\_cw\_sns\_subscription\_email) | Email for receiving CW alarm notifications | `string` | n/a | yes |
| <a name="input_enable_cis_alarms"></a> [enable\_cis\_alarms](#input\_enable\_cis\_alarms) | Whether to create the cis Cloudwatch log metric filter and metric alarms | `bool` | `true` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment | `string` | n/a | yes |
| <a name="input_lb_arn_suffix"></a> [lb\_arn\_suffix](#input\_lb\_arn\_suffix) | ARN suffix of our load balancer | `string` | n/a | yes |
| <a name="input_syn_canary_success_threshold"></a> [syn\_canary\_success\_threshold](#input\_syn\_canary\_success\_threshold) | Cloudwatch synthetic canary Success percentage threshold | `string` | `"90"` | no |
| <a name="input_synthetics_canary_name"></a> [synthetics\_canary\_name](#input\_synthetics\_canary\_name) | Name for cloudwatch synthetics canary | `string` | `"canary-demo"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarm_sns_topic_arn"></a> [alarm\_sns\_topic\_arn](#output\_alarm\_sns\_topic\_arn) | The ARN of the SNS topic for cloud watch alarms |
| <a name="output_alb_alarm_arn"></a> [alb\_alarm\_arn](#output\_alb\_alarm\_arn) | ARN of the APP load balancer 4xx cloudWatch Metric Alarm |
| <a name="output_asg_cpu_alarm_arn"></a> [asg\_cpu\_alarm\_arn](#output\_asg\_cpu\_alarm\_arn) | ARN of the ASG CPU cloudwatch Metric Alarm |
| <a name="output_cis_alarm_arns"></a> [cis\_alarm\_arns](#output\_cis\_alarm\_arns) | List of ARNs of the CIS Cloudwatch metric alarm |
| <a name="output_cw_syn_canaray_alarm_arn"></a> [cw\_syn\_canaray\_alarm\_arn](#output\_cw\_syn\_canaray\_alarm\_arn) | ARN of the synthetic canary cloudWatch Metric Alarm |
| <a name="output_cw_syn_canaray_arn"></a> [cw\_syn\_canaray\_arn](#output\_cw\_syn\_canaray\_arn) | ARN of the cloudwatch synthetic canary |
<!-- END_TF_DOCS -->