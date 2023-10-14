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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_notification.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_notification) | resource |
| [aws_autoscaling_policy.alb_requests_per_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_autoscaling_policy.asg_avg_cpu_util](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_iam_instance_profile.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ec2_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_launch_template.app_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_sns_topic.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_iam_policy_document.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_asg_max_size"></a> [asg\_max\_size](#input\_asg\_max\_size) | Maximum size of the Auto Scaling Group | `number` | `6` | no |
| <a name="input_asg_min_size"></a> [asg\_min\_size](#input\_asg\_min\_size) | Maximum size of the Auto Scaling Group | `number` | `2` | no |
| <a name="input_asg_name"></a> [asg\_name](#input\_asg\_name) | Name of the Auto Scaling Group | `string` | `"app-asg"` | no |
| <a name="input_asg_sns_subscription_email"></a> [asg\_sns\_subscription\_email](#input\_asg\_sns\_subscription\_email) | Email for receiving asg and CW alarm notifications | `string` | n/a | yes |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Number of Amazon EC2 instances that should be running in the Auto Scaling Group | `number` | `2` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment | `string` | n/a | yes |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | The AMI from which to launch the instance | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type of instance to start | `string` | `"t3.micro"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | launch template Key name for ec2 Key Pair | `string` | n/a | yes |
| <a name="input_launch_template_name_prefix"></a> [launch\_template\_name\_prefix](#input\_launch\_template\_name\_prefix) | Name prefix of Launch template | `string` | `"app-lt"` | no |
| <a name="input_lb_arn_suffix"></a> [lb\_arn\_suffix](#input\_lb\_arn\_suffix) | ARN suffix of load balancer | `string` | n/a | yes |
| <a name="input_lt_user_data"></a> [lt\_user\_data](#input\_lt\_user\_data) | base64-encoded user data to provide when launching the instance | `any` | n/a | yes |
| <a name="input_target_group_arn_suffix"></a> [target\_group\_arn\_suffix](#input\_target\_group\_arn\_suffix) | ARN suffixes of target group | `string` | n/a | yes |
| <a name="input_target_group_arns"></a> [target\_group\_arns](#input\_target\_group\_arns) | target\_group ARNs for use with Application Load Balancer | `list(string)` | n/a | yes |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | A list of security group IDs to associate with | `list(string)` | n/a | yes |
| <a name="input_vpc_zone_identifier"></a> [vpc\_zone\_identifier](#input\_vpc\_zone\_identifier) | List of subnet IDs to launch resources in | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_servers_iam_role"></a> [app\_servers\_iam\_role](#output\_app\_servers\_iam\_role) | The IAM role ARN of EC2 instance profile |
| <a name="output_app_servers_instance_profile"></a> [app\_servers\_instance\_profile](#output\_app\_servers\_instance\_profile) | The ARN assigned by AWS to the EC2 instance profile |
| <a name="output_asg_arn"></a> [asg\_arn](#output\_asg\_arn) | Auto-scaling group arn |
| <a name="output_asg_name"></a> [asg\_name](#output\_asg\_name) | Auto-scaling group name |
| <a name="output_asg_sns_topic"></a> [asg\_sns\_topic](#output\_asg\_sns\_topic) | The ARN of the SNS topic for asg notifications |
| <a name="output_lt_arn"></a> [lt\_arn](#output\_lt\_arn) | The ARN of the launch template |
| <a name="output_lt_latest_version"></a> [lt\_latest\_version](#output\_lt\_latest\_version) | The latest version of the launch template |
<!-- END_TF_DOCS -->