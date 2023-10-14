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
| <a name="provider_local"></a> [local](#provider\_local) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_stack.chatbot_slack_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack) | resource |
| [aws_codestarnotifications_notification_rule.pipeline_status](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarnotifications_notification_rule) | resource |
| [aws_iam_role.chatbot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_invoke](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.notifications_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.read_commands](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [local_file.cloudformation_template](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_configuration_name"></a> [configuration\_name](#input\_configuration\_name) | The name of the configuration. | `string` | `"cpipeline-status"` | no |
| <a name="input_guardrail_policies"></a> [guardrail\_policies](#input\_guardrail\_policies) | The list of IAM policy ARNs that are applied as channel guardrails. The AWS managed 'AdministratorAccess' policy is applied as a default if this is not set. | `list` | <pre>[<br>  "arn:aws:iam::aws:policy/AdministratorAccess"<br>]</pre> | no |
| <a name="input_logging_level"></a> [logging\_level](#input\_logging\_level) | Specifies the logging level for this configuration. This property affects the log entries pushed to Amazon CloudWatch Logs. Logging levels include ERROR, INFO, or NONE. | `string` | `"ERROR"` | no |
| <a name="input_notification_rules_config"></a> [notification\_rules\_config](#input\_notification\_rules\_config) | pipeline notification rule configuration | <pre>map(object({<br>    notification_rule_name = string<br>    pipeline_arn           = string<br>    event_type_ids         = list(string)<br>    detail_type            = string<br>  }))</pre> | <pre>{<br>  "rule_cp": {<br>    "detail_type": "BASIC",<br>    "event_type_ids": [<br>      "codepipeline-pipeline-pipeline-execution-started",<br>      "codepipeline-pipeline-pipeline-execution-failed",<br>      "codepipeline-pipeline-pipeline-execution-canceled",<br>      "codepipeline-pipeline-pipeline-execution-succeeded",<br>      "codepipeline-pipeline-manual-approval-needed",<br>      "codepipeline-pipeline-manual-approval-succeeded",<br>      "codepipeline-pipeline-manual-approval-failed"<br>    ],<br>    "notification_rule_name": null,<br>    "pipeline_arn": null<br>  }<br>}</pre> | no |
| <a name="input_slack_channel_id"></a> [slack\_channel\_id](#input\_slack\_channel\_id) | The ID of the Slack channel. To get the ID, open Slack, right click on the channel name in the left pane, then choose Copy Link. The channel ID is the 9-character string at the end of the URL. For example, ABCBBLZZZ. | `any` | n/a | yes |
| <a name="input_slack_workspace_id"></a> [slack\_workspace\_id](#input\_slack\_workspace\_id) | The ID of the Slack workspace authorized with AWS Chatbot. To get the workspace ID, you must perform the initial authorization flow with Slack in the AWS Chatbot console. Then you can copy and paste the workspace ID from the console. For more details, see steps 1-4 in [Setting Up AWS Chatbot with Slack](https://docs.aws.amazon.com/chatbot/latest/adminguide/setting-up.html#Setup_intro) in the AWS Chatbot User Guide. | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_chatbot_role"></a> [chatbot\_role](#output\_chatbot\_role) | IAM role for AWS chatbot |
| <a name="output_configuration_arn"></a> [configuration\_arn](#output\_configuration\_arn) | The ARN of the Chatbot Slack configuration |
| <a name="output_pipeline_notification_rule_arns"></a> [pipeline\_notification\_rule\_arns](#output\_pipeline\_notification\_rule\_arns) | List of codestar notification rule ARNs for pipeline status |
| <a name="output_stack_id"></a> [stack\_id](#output\_stack\_id) | The unique identifier for the stack. |
<!-- END_TF_DOCS -->