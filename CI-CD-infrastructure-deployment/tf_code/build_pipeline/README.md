<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.44.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.cicd_act"></a> [aws.cicd\_act](#provider\_aws.cicd\_act) | 5.20.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dev_backend"></a> [dev\_backend](#module\_dev\_backend) | ./modules/setup-backend | n/a |
| <a name="module_dev_cross_act_role"></a> [dev\_cross\_act\_role](#module\_dev\_cross\_act\_role) | ./modules/cross-act-target-role | n/a |
| <a name="module_dev_pipeline"></a> [dev\_pipeline](#module\_dev\_pipeline) | ./modules/setup-pipeline | n/a |
| <a name="module_slack_notification"></a> [slack\_notification](#module\_slack\_notification) | ./modules/pipeline-chatbot-slack | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.cb_image](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_s3_bucket.infracost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.infracost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_versioning.infracost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_secretsmanager_secret.infracost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.infracost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_ses_email_identity.email_infracost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_email_identity) | resource |
| [aws_ssm_parameter.email_infracost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.infracost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [null_resource.create_ecr_image](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_integer.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | Infracost api key for cost estimates | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region to deploy resources | `string` | `"us-east-1"` | no |
| <a name="input_cb_ecr_repo"></a> [cb\_ecr\_repo](#input\_cb\_ecr\_repo) | ECR repo name for codebuild environment | `string` | `"codebuild/custom-tf-tools"` | no |
| <a name="input_cicd_act_no"></a> [cicd\_act\_no](#input\_cicd\_act\_no) | CI/CD tooling Account number | `string` | n/a | yes |
| <a name="input_cicd_act_profile"></a> [cicd\_act\_profile](#input\_cicd\_act\_profile) | Name of profile used for CICD account | `string` | n/a | yes |
| <a name="input_dev_act_profile"></a> [dev\_act\_profile](#input\_dev\_act\_profile) | Name of AWS profile used for dev account | `string` | n/a | yes |
| <a name="input_dev_codepipeline_name"></a> [dev\_codepipeline\_name](#input\_dev\_codepipeline\_name) | Name of the pipeline | `string` | `"dev-infra-pipeline"` | no |
| <a name="input_dev_deploy_stage_name"></a> [dev\_deploy\_stage\_name](#input\_dev\_deploy\_stage\_name) | Name of deploy stage | `string` | `"Deploy-dev"` | no |
| <a name="input_dev_repo_name"></a> [dev\_repo\_name](#input\_dev\_repo\_name) | Name for the repository | `string` | `"dev-environment"` | no |
| <a name="input_email_infracost_reports"></a> [email\_infracost\_reports](#input\_email\_infracost\_reports) | Email to send infracost email | `string` | n/a | yes |
| <a name="input_pipeline_approval_email_id"></a> [pipeline\_approval\_email\_id](#input\_pipeline\_approval\_email\_id) | Eamil id for manual approval | `string` | n/a | yes |
| <a name="input_slack_channel_id"></a> [slack\_channel\_id](#input\_slack\_channel\_id) | The ID of the Slack channel. To get the ID, open Slack, right click on the channel name in the left pane, then choose Copy Link. The channel ID is the 9-character string at the end of the URL. For example, ABCBBLZZZ. | `string` | n/a | yes |
| <a name="input_slack_workspace_id"></a> [slack\_workspace\_id](#input\_slack\_workspace\_id) | The ID of the Slack workspace authorized with AWS Chatbot. To get the workspace ID, you must perform the initial authorization flow with Slack in the AWS Chatbot console. Then you can copy and paste the workspace ID from the console. For more details, see steps 1-4 in [Setting Up AWS Chatbot with Slack](https://docs.aws.amazon.com/chatbot/latest/adminguide/setting-up.html#Setup_intro) in the AWS Chatbot User Guide. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to assign to ecr repo | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_chatbot_CFN_stack_id"></a> [chatbot\_CFN\_stack\_id](#output\_chatbot\_CFN\_stack\_id) | The unique ID for Cloudformation stack used to setup slack integration |
| <a name="output_dev_backend_arn"></a> [dev\_backend\_arn](#output\_dev\_backend\_arn) | ARN of the bucket for S3 backend for dev env |
| <a name="output_dev_cp_arn"></a> [dev\_cp\_arn](#output\_dev\_cp\_arn) | codepipeline ARN |
| <a name="output_dev_cross_act_role_arn"></a> [dev\_cross\_act\_role\_arn](#output\_dev\_cross\_act\_role\_arn) | Arn of cross account role in dev acct |
| <a name="output_dev_dynamo_lock_arn"></a> [dev\_dynamo\_lock\_arn](#output\_dev\_dynamo\_lock\_arn) | Arn of dynamodb table for remote state for dev env |
| <a name="output_ecr_repo_url"></a> [ecr\_repo\_url](#output\_ecr\_repo\_url) | Url of ecr repository |
| <a name="output_infracost_secretmanager_name"></a> [infracost\_secretmanager\_name](#output\_infracost\_secretmanager\_name) | Name of secretmanager for infracost apikey |
| <a name="output_notification_rule_arns"></a> [notification\_rule\_arns](#output\_notification\_rule\_arns) | List of codestar notification rule ARNs for pipeline status |
<!-- END_TF_DOCS -->