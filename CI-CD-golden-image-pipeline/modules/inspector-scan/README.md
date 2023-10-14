<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.44.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.44.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_inspector_assessment_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/inspector_assessment_target) | resource |
| [aws_inspector_assessment_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/inspector_assessment_template) | resource |
| [aws_inspector_resource_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/inspector_resource_group) | resource |
| [aws_ses_email_identity.findings_report](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_email_identity) | resource |
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_ssm_parameter.email_contact](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.target_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.template_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | AccountID to apply to sns topic access policy | `string` | n/a | yes |
| <a name="input_duration"></a> [duration](#input\_duration) | The duration in secs of the inspector run | `string` | `"900"` | no |
| <a name="input_inspector_email_id"></a> [inspector\_email\_id](#input\_inspector\_email\_id) | Email to receive notification events | `string` | n/a | yes |
| <a name="input_rules_package_arns"></a> [rules\_package\_arns](#input\_rules\_package\_arns) | n/a | `list(string)` | <pre>[<br>  "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-R01qwB5Q",<br>  "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-gEjTy7T7",<br>  "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-rExsr2X8"<br>]</pre> | no |
| <a name="input_sns_topic_name"></a> [sns\_topic\_name](#input\_sns\_topic\_name) | SNS topic for Inspector notification events | `string` | `"aws-inspector-alerts"` | no |
| <a name="input_target"></a> [target](#input\_target) | The name of the assessment target | `string` | `"target-golden-amis"` | no |
| <a name="input_target_resource_tags"></a> [target\_resource\_tags](#input\_target\_resource\_tags) | Key-value map of tags that are used to select the EC2 instances | `map(any)` | <pre>{<br>  "AwsInspectorScan": "True"<br>}</pre> | no |
| <a name="input_template_name"></a> [template\_name](#input\_template\_name) | The name of the assessment template | `string` | `"Scan-golden-ami-instances"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_assessment_target_arn"></a> [assessment\_target\_arn](#output\_assessment\_target\_arn) | n/a |
| <a name="output_assessment_template_arn"></a> [assessment\_template\_arn](#output\_assessment\_template\_arn) | n/a |
| <a name="output_parameter_store_email_contact"></a> [parameter\_store\_email\_contact](#output\_parameter\_store\_email\_contact) | n/a |
| <a name="output_parameter_store_target_arn"></a> [parameter\_store\_target\_arn](#output\_parameter\_store\_target\_arn) | n/a |
| <a name="output_parameter_store_template_arn"></a> [parameter\_store\_template\_arn](#output\_parameter\_store\_template\_arn) | n/a |
<!-- END_TF_DOCS -->