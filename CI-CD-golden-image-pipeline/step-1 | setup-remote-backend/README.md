<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.44.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_main_backend"></a> [main\_backend](#module\_main\_backend) | ../modules/setup-backend | n/a |
| <a name="module_pipeline_backend"></a> [pipeline\_backend](#module\_pipeline\_backend) | ../modules/setup-backend | n/a |

## Resources

| Name | Type |
|------|------|
| [random_integer.gami](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [random_integer.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region to deploy resources | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_main_s3_bucket_id"></a> [main\_s3\_bucket\_id](#output\_main\_s3\_bucket\_id) | Name of the bucket for S3 backend (ami-pipeline) |
| <a name="output_main_table_id"></a> [main\_table\_id](#output\_main\_table\_id) | Name of dynamodb table for remote state (ami-pipeline) |
| <a name="output_pipeline_s3_bucket_id"></a> [pipeline\_s3\_bucket\_id](#output\_pipeline\_s3\_bucket\_id) | Name of the bucket for S3 backend (ami-pipeline) |
| <a name="output_pipeline_table_id"></a> [pipeline\_table\_id](#output\_pipeline\_table\_id) | Name of dynamodb table for remote state (ami-pipeline) |
<!-- END_TF_DOCS -->