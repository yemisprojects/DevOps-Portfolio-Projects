########################### STS ###########################
data "aws_caller_identity" "caller_id" {}

########################### LOCALS ###########################
locals {
  account_id        = data.aws_caller_identity.caller_id.account_id
  sns_topic_name =    "report-failed-remediation"
  ssm_document_name = "ConfigRemediation-EnableSQSEncryptionWithKMS"
  config_rule_name = "sqs-queue-kms-encryption-enabled"
}

###################### AWS CUSTOM CONFIG RULE ######################
resource "aws_config_config_rule" "sqs_encryption_rule" {
  name        = local.config_rule_name
  description = "Checks whether AWS SQS Queue is configured to use the server side encryption (SSE) AWS Key Management Service (AWS KMS) customer master key (CMK) encryption. The rule is compliant if the KmsKeyId is defined."
  scope {
    compliance_resource_types = ["AWS::SQS::Queue"]
  }
  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = aws_lambda_function.compliance_evaluator.arn
    source_detail {
      message_type = "ConfigurationItemChangeNotification"
    }
    source_detail {
      message_type = "OversizedConfigurationItemChangeNotification"
    }
  }
}

###################### CONFIG RULE REMEDIATION ######################
resource "aws_config_remediation_configuration" "sqs_remediation" {
  config_rule_name = aws_config_config_rule.sqs_encryption_rule.name
  depends_on = [
    aws_ssm_document.remediate_sqs_queue
  ]
  resource_type    = "AWS::SQS::Queue"
  target_type      = "SSM_DOCUMENT"
  target_id        = local.ssm_document_name

  parameter {
    name           = "QueueUrl"
    resource_value = "RESOURCE_ID"
  }
  parameter {
    name         = "AutomationAssumeRole"
    static_value = aws_iam_role.automation_role.arn
  }
  parameter {
    name         = "KmsKeyId"
    static_value = "alias/aws/sqs"
  }

  automatic                  = true
  maximum_automatic_attempts = 5
  retry_attempt_seconds      = 300

  execution_controls {
    ssm_controls {
      concurrent_execution_rate_percentage = 20
      error_percentage                     = 20
    }
  }
}

###################### CONFIG RULE LAMBDA PERMISSION ######################
resource "aws_lambda_permission" "config_rule_lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.compliance_evaluator.arn
  principal     = "config.amazonaws.com"
  statement_id  = "AllowExecutionFromConfig"
}

###################### SENDER EMAIL SES IDENTITY ######################
resource "aws_ses_email_identity" "email_id" {
  email = var.sender_email_address
}

###################### SNS TOPIC TO SEND FAILED AUTOMATION ######################
resource "aws_sns_topic" "report_failed_remediation_topic" {
  name              = local.sns_topic_name
  kms_master_key_id = "alias/aws/sns"
}

###################### SNS SUBSCRIPTION TO RECEIVE FAILED AUTOMATION ######################
resource "aws_sns_topic_subscription" "admin_target" {
  topic_arn = aws_sns_topic.report_failed_remediation_topic.arn
  protocol  = "email"
  endpoint  = var.sns_email_address
}

###################### SSM DOCUMENT ######################
resource "aws_ssm_document" "remediate_sqs_queue" {
  name            = local.ssm_document_name
  document_format = "YAML"
  document_type   = "Automation"

  content = templatefile("${path.module}/ssm_document/sqs_ssm_document.tftpl", { 
                                                                                sns_topic_arn = aws_sns_topic.report_failed_remediation_topic.arn 
                                                                                config_rule_name = local.config_rule_name
                                                                                }
                        )
}