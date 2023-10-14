A<!-- BEGIN_TF_DOCS -->
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
| [aws_iam_role.cross_act](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.deploy_infra](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cicd_act_no"></a> [cicd\_act\_no](#input\_cicd\_act\_no) | CI/CD tooling Account number | `string` | n/a | yes |
| <a name="input_cross_act_role_name"></a> [cross\_act\_role\_name](#input\_cross\_act\_role\_name) | Name of cross account IAM role to deploy infrastructure | `string` | `"Pipeline-Deploy-Infrastructure"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cross_act_role_arn"></a> [cross\_act\_role\_arn](#output\_cross\_act\_role\_arn) | Arn of cross account role |
<!-- END_TF_DOCS -->