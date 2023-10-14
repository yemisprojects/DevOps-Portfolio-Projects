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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_golden_ami_pipeline"></a> [golden\_ami\_pipeline](#module\_golden\_ami\_pipeline) | ../modules/setup-pipeline | n/a |
| <a name="module_inspector_ec2_instance"></a> [inspector\_ec2\_instance](#module\_inspector\_ec2\_instance) | ../modules/inspector-scan | n/a |
| <a name="module_slack_notification"></a> [slack\_notification](#module\_slack\_notification) | ../modules/pipeline-chatbot-slack | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.inspector](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_codepipeline_name"></a> [ami\_codepipeline\_name](#input\_ami\_codepipeline\_name) | Name of the pipeline | `string` | `"golden-ami-pipeline"` | no |
| <a name="input_ami_deploy_stage_name"></a> [ami\_deploy\_stage\_name](#input\_ami\_deploy\_stage\_name) | Name of deploy stage | `string` | `"Share-AMI"` | no |
| <a name="input_ami_repo_name"></a> [ami\_repo\_name](#input\_ami\_repo\_name) | Name for the repository | `string` | `"golden-ami-repo"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region to deploy resources | `string` | `"us-east-1"` | no |
| <a name="input_event_type_ids"></a> [event\_type\_ids](#input\_event\_type\_ids) | List of pipeline events to recieve notification on | `list(string)` | <pre>[<br>  "codepipeline-pipeline-pipeline-execution-started",<br>  "codepipeline-pipeline-pipeline-execution-failed",<br>  "codepipeline-pipeline-pipeline-execution-canceled",<br>  "codepipeline-pipeline-pipeline-execution-succeeded",<br>  "codepipeline-pipeline-manual-approval-needed",<br>  "codepipeline-pipeline-manual-approval-succeeded",<br>  "codepipeline-pipeline-manual-approval-failed"<br>]</pre> | no |
| <a name="input_inspector_email_id"></a> [inspector\_email\_id](#input\_inspector\_email\_id) | Eamil id for inspector assessment run notifications | `string` | n/a | yes |
| <a name="input_pipeline_approval_email_id"></a> [pipeline\_approval\_email\_id](#input\_pipeline\_approval\_email\_id) | Eamil id for manual approval | `string` | n/a | yes |
| <a name="input_scan_duration"></a> [scan\_duration](#input\_scan\_duration) | The duration in secs of the inspector run | `string` | `"300"` | no |
| <a name="input_slack_channel_id"></a> [slack\_channel\_id](#input\_slack\_channel\_id) | The ID of the Slack channel. To get the ID, open Slack, right click on the channel name in the left pane, then choose Copy Link. The channel ID is the 9-character string at the end of the URL. For example, ABCBBLZZZ. | `string` | n/a | yes |
| <a name="input_slack_workspace_id"></a> [slack\_workspace\_id](#input\_slack\_workspace\_id) | The ID of the Slack workspace authorized with AWS Chatbot. To get the workspace ID, you must perform the initial authorization flow with Slack in the AWS Chatbot console. Then you can copy and paste the workspace ID from the console. For more details, see steps 1-4 in [Setting Up AWS Chatbot with Slack](https://docs.aws.amazon.com/chatbot/latest/adminguide/setting-up.html#Setup_intro) in the AWS Chatbot User Guide. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ami_cb_project_names"></a> [ami\_cb\_project\_names](#output\_ami\_cb\_project\_names) | Names of all codebuild projects |
| <a name="output_ami_cb_service_role_arn"></a> [ami\_cb\_service\_role\_arn](#output\_ami\_cb\_service\_role\_arn) | Codebuild project service role arn |
| <a name="output_ami_clone_http_url"></a> [ami\_clone\_http\_url](#output\_ami\_clone\_http\_url) | URL to use for cloning the repository over HTTPS |
| <a name="output_ami_clone_ssh_url"></a> [ami\_clone\_ssh\_url](#output\_ami\_clone\_ssh\_url) | URL to use for cloning the repository over SSH. |
| <a name="output_ami_cp_arn"></a> [ami\_cp\_arn](#output\_ami\_cp\_arn) | codepipeline ARN |
| <a name="output_ami_cp_service_role_arn"></a> [ami\_cp\_service\_role\_arn](#output\_ami\_cp\_service\_role\_arn) | Codepipeline service role arn |
| <a name="output_assessment_target_arn"></a> [assessment\_target\_arn](#output\_assessment\_target\_arn) | n/a |
| <a name="output_assessment_template_arn"></a> [assessment\_template\_arn](#output\_assessment\_template\_arn) | n/a |
| <a name="output_configuration_arn"></a> [configuration\_arn](#output\_configuration\_arn) | The ARN of the Chatbot Slack configuration |
| <a name="output_inspector_parameter_store_email_contact"></a> [inspector\_parameter\_store\_email\_contact](#output\_inspector\_parameter\_store\_email\_contact) | n/a |
| <a name="output_inspector_parameter_store_target_arn"></a> [inspector\_parameter\_store\_target\_arn](#output\_inspector\_parameter\_store\_target\_arn) | n/a |
| <a name="output_inspector_parameter_store_template_arn"></a> [inspector\_parameter\_store\_template\_arn](#output\_inspector\_parameter\_store\_template\_arn) | ############################################################################### OUTPUTS - inspector ############################################################################### |
| <a name="output_notification_rule_arns"></a> [notification\_rule\_arns](#output\_notification\_rule\_arns) | List of codestar notification rule ARNs for pipeline status |
| <a name="output_slack_stack_id"></a> [slack\_stack\_id](#output\_slack\_stack\_id) | The unique ID for Cloudformation stack used to setup slack integration |
<!-- END_TF_DOCS -->