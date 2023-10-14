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
| <a name="provider_aws.dns_act_owner"></a> [aws.dns\_act\_owner](#provider\_aws.dns\_act\_owner) | >= 4.46 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_route53_record.validation_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.public_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_domain_name"></a> [acm\_domain\_name](#input\_acm\_domain\_name) | n/a | `string` | `"prod.devopscloudemos.tk"` | no |
| <a name="input_acm_subject_alternate_names"></a> [acm\_subject\_alternate\_names](#input\_acm\_subject\_alternate\_names) | n/a | `list(string)` | `null` | no |
| <a name="input_r53_zone_name"></a> [r53\_zone\_name](#input\_r53\_zone\_name) | route53 hosted zone name | `string` | n/a | yes |
| <a name="input_validation_timeout"></a> [validation\_timeout](#input\_validation\_timeout) | Define maximum timeout to wait for the validation to complete | `string` | `"75m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acm_certificate_arn"></a> [acm\_certificate\_arn](#output\_acm\_certificate\_arn) | The ARN of the certificate |
| <a name="output_acm_certificate_status"></a> [acm\_certificate\_status](#output\_acm\_certificate\_status) | Status of the certificate. |
| <a name="output_validation_r53_records"></a> [validation\_r53\_records](#output\_validation\_r53\_records) | n/a |
<!-- END_TF_DOCS -->