<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.44.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.44.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.4.3 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.pipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.pipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_codebuild_project.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codecommit_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_repository) | resource |
| [aws_codepipeline.golden_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_codepipeline.non_prod_infra](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_codepipeline.prod_infra_pipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_codestarnotifications_notification_rule.pipeline_status](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarnotifications_notification_rule) | resource |
| [aws_iam_role.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.codepipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.event_bridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.codepipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.event_bridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.cb_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.codepipeline_artifact_store](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.codepipeline_artifact_store](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.codepipeline_artifact_store](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.codepipeline_artifact_store](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_versioning.codepipeline_artifact_store](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_sns_topic.pipeline_approval](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic.pipeline_status](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.pipeline_approval](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sns_topic_subscription.pipeline_status](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [random_id.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_integer.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [template_file.ami_pipeline](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.infra_pipeline](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_branch_name"></a> [branch\_name](#input\_branch\_name) | Name of the branch where source changes are to be detected | `string` | `"main"` | no |
| <a name="input_cb_image"></a> [cb\_image](#input\_cb\_image) | codebuild environment image | `string` | `"aws/codebuild/amazonlinux2-x86_64-standard:4.0"` | no |
| <a name="input_cb_project_configs"></a> [cb\_project\_configs](#input\_cb\_project\_configs) | Configuration for each codebuild project | <pre>map(object( { <br>                              project_name = string<br>                              buildspec_path = string<br>                            }<br>                          )<br>                    )</pre> | <pre>{<br>  "sample_project": {<br>    "buildspec_path": "buildspecs/x.yml",<br>    "project_name": "project-x"<br>  }<br>}</pre> | no |
| <a name="input_codebuild_bucket_tags"></a> [codebuild\_bucket\_tags](#input\_codebuild\_bucket\_tags) | Tags to assign to codebuild log bucket | `map(string)` | `{}` | no |
| <a name="input_codebuild_tags"></a> [codebuild\_tags](#input\_codebuild\_tags) | Tags to assign to all codebuild projects | `map(string)` | `{}` | no |
| <a name="input_codepipeline_approval_sns_topic"></a> [codepipeline\_approval\_sns\_topic](#input\_codepipeline\_approval\_sns\_topic) | Name of sns topic to use for manual approval in Pipeline | `string` | `"pipeline-approval"` | no |
| <a name="input_codepipeline_bucket_tags"></a> [codepipeline\_bucket\_tags](#input\_codepipeline\_bucket\_tags) | Tags to assign to codepipeline artifact bucket | `map(string)` | `{}` | no |
| <a name="input_codepipeline_name"></a> [codepipeline\_name](#input\_codepipeline\_name) | Name of the pipeline | `string` | `"Demo-Infra-Pipeline"` | no |
| <a name="input_codepipeline_tags"></a> [codepipeline\_tags](#input\_codepipeline\_tags) | Tags to assign to CodePipeline | `map(string)` | `{}` | no |
| <a name="input_create_sns_notification_rule"></a> [create\_sns\_notification\_rule](#input\_create\_sns\_notification\_rule) | Create rule for pipeline status notifications using SNS | `bool` | `false` | no |
| <a name="input_deletion_window_days"></a> [deletion\_window\_days](#input\_deletion\_window\_days) | Waiting period after which to delete kms key | `number` | `7` | no |
| <a name="input_deploy_stage_name"></a> [deploy\_stage\_name](#input\_deploy\_stage\_name) | Name of deploy stage (last stage in the pipeline) | `string` | `"Deploy"` | no |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation) | Enable key rotation | `bool` | `true` | no |
| <a name="input_event_bridge_rule_tags"></a> [event\_bridge\_rule\_tags](#input\_event\_bridge\_rule\_tags) | Tags to assign to eventbridge rule | `map(string)` | `{}` | no |
| <a name="input_git_tag_trigger"></a> [git\_tag\_trigger](#input\_git\_tag\_trigger) | git tag suffix used to start the pipeline | `string` | `null` | no |
| <a name="input_kms_key_alias"></a> [kms\_key\_alias](#input\_kms\_key\_alias) | Alias of S3 Kms key | `string` | `"alias/demo-pipeline"` | no |
| <a name="input_kms_key_tags"></a> [kms\_key\_tags](#input\_kms\_key\_tags) | Tags to assign to kms key | `map(string)` | `{}` | no |
| <a name="input_pipeline_approval_email_id"></a> [pipeline\_approval\_email\_id](#input\_pipeline\_approval\_email\_id) | Eamil id for manual approval | `string` | `null` | no |
| <a name="input_pipeline_status_email_id"></a> [pipeline\_status\_email\_id](#input\_pipeline\_status\_email\_id) | Eamil id for pipeline status notifications | `string` | `null` | no |
| <a name="input_pipeline_status_sns_topic"></a> [pipeline\_status\_sns\_topic](#input\_pipeline\_status\_sns\_topic) | Name of sns topic to publish for Pipeline status | `string` | `"pipeline-status"` | no |
| <a name="input_pipeline_type"></a> [pipeline\_type](#input\_pipeline\_type) | Purpose of pipeline | `string` | `"ami-pipeline"` | no |
| <a name="input_repo_description"></a> [repo\_description](#input\_repo\_description) | Purpose of repo | `string` | `"Repo for app or infra code"` | no |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | Name for the repository | `string` | `"infra-repo"` | no |
| <a name="input_repo_tags"></a> [repo\_tags](#input\_repo\_tags) | Tags to associate to repo | `map(string)` | `{}` | no |
| <a name="input_s3_bucket_force_destroy"></a> [s3\_bucket\_force\_destroy](#input\_s3\_bucket\_force\_destroy) | Forcefully destroy all S3 pipeline and codebuild buckets without error | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_clone_ssh_url"></a> [clone\_ssh\_url](#output\_clone\_ssh\_url) | URL to use for cloning the repository over SSH. |
| <a name="output_codebuild_project_arns"></a> [codebuild\_project\_arns](#output\_codebuild\_project\_arns) | ARNs of all codebuild projects |
| <a name="output_codebuild_project_service_role_arn"></a> [codebuild\_project\_service\_role\_arn](#output\_codebuild\_project\_service\_role\_arn) | Codebuild project service role arn |
| <a name="output_codepipeline_arn"></a> [codepipeline\_arn](#output\_codepipeline\_arn) | codepipeline ARN |
| <a name="output_codepipeline_artifact_bucket_arn"></a> [codepipeline\_artifact\_bucket\_arn](#output\_codepipeline\_artifact\_bucket\_arn) | ARN of Codepipeline artificat Bucket |
| <a name="output_codepipeline_service_role_arn"></a> [codepipeline\_service\_role\_arn](#output\_codepipeline\_service\_role\_arn) | Codepipeline service role arn |
| <a name="output_kms_key_alias"></a> [kms\_key\_alias](#output\_kms\_key\_alias) | Alias of kms key used by codebuild |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | Arn of kms key used by codebuild |
| <a name="output_pipeline_notification_rule_arn"></a> [pipeline\_notification\_rule\_arn](#output\_pipeline\_notification\_rule\_arn) | The codestar notification rule ARN for pipeline status |
| <a name="output_repo_arn"></a> [repo\_arn](#output\_repo\_arn) | ARN of repo |
<!-- END_TF_DOCS -->