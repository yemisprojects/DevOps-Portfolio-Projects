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
| [aws_dynamodb_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_kms_key.s3_kms_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of S3 bucket | `string` | n/a | yes |
| <a name="input_bucket_tags"></a> [bucket\_tags](#input\_bucket\_tags) | Tags to assign to bucket | `map(string)` | `{}` | no |
| <a name="input_create_cmk_sse_kms"></a> [create\_cmk\_sse\_kms](#input\_create\_cmk\_sse\_kms) | Create a customer managed key for SSE-KMS instead of default AWS managed kms key(aws/s3) | `bool` | `false` | no |
| <a name="input_deletion_window_days"></a> [deletion\_window\_days](#input\_deletion\_window\_days) | Waiting period after which to delete kms key | `number` | `7` | no |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation) | Enable key rotation | `bool` | `true` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Delete all objects from the bucket without error | `bool` | `true` | no |
| <a name="input_kms_key_alias"></a> [kms\_key\_alias](#input\_kms\_key\_alias) | Alias of S3 Kms key | `string` | `"alias/s3-backend"` | no |
| <a name="input_kms_key_tags"></a> [kms\_key\_tags](#input\_kms\_key\_tags) | Tags to assign to KMS Key | `map(string)` | `{}` | no |
| <a name="input_s3_sse_algorithm"></a> [s3\_sse\_algorithm](#input\_s3\_sse\_algorithm) | S3 Server-side encryption algorithm to use | `string` | `"AES256"` | no |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | Name of dynamodb table | `string` | n/a | yes |
| <a name="input_table_tags"></a> [table\_tags](#input\_table\_tags) | Tags to add to dynamodb table | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | ARN of Customer KMS key for S3 bucket |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | Customer KMS Key Id for S3 bucket |
| <a name="output_managed_kms_key_arn"></a> [managed\_kms\_key\_arn](#output\_managed\_kms\_key\_arn) | AWS Managed KMS Key ARN for S3 bucket |
| <a name="output_managed_kms_key_id"></a> [managed\_kms\_key\_id](#output\_managed\_kms\_key\_id) | AWS Managed KMS Key Id for S3 bucket |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | ARN of the bucket for S3 backend |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | Name of the bucket for S3 backend |
| <a name="output_table_arn"></a> [table\_arn](#output\_table\_arn) | Arn of dynamodb table for remote state |
| <a name="output_table_id"></a> [table\_id](#output\_table\_id) | Name of dynamodb table for remote state |
<!-- END_TF_DOCS -->