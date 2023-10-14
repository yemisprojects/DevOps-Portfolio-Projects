output "assessment_target_arn" {
  value = aws_inspector_assessment_target.this.arn
}

output "assessment_template_arn" {
  value = aws_inspector_assessment_template.this.arn
}

output "parameter_store_template_arn" {
  value = aws_ssm_parameter.template_arn.name
}

output "parameter_store_email_contact" {
  value = aws_ssm_parameter.email_contact.name
}

output "parameter_store_target_arn" {
  value = aws_ssm_parameter.target_arn.name
}


