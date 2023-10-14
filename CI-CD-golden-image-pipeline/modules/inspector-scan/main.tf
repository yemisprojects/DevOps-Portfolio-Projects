################################################################################
# AWS INSPECTOR
################################################################################
resource "aws_inspector_resource_group" "this" {
  tags = var.target_resource_tags
}

resource "aws_inspector_assessment_target" "this" {
  name               = var.target
  resource_group_arn = aws_inspector_resource_group.this.arn
}

resource "aws_inspector_assessment_template" "this" {
  name       = var.template_name
  target_arn = aws_inspector_assessment_target.this.arn
  duration   = var.duration

  rules_package_arns = var.rules_package_arns

  event_subscription {
    event     = "ASSESSMENT_RUN_COMPLETED"
    topic_arn = aws_sns_topic.this.arn
  }

  event_subscription {
    event     = "ASSESSMENT_RUN_STARTED"
    topic_arn = aws_sns_topic.this.arn
  }
}


################################################################################
# AWS INSPECTOR NOTIFICATIONS
################################################################################
resource "aws_sns_topic" "this" {
  name = var.sns_topic_name
}

resource "aws_ses_email_identity" "findings_report" {
  email = var.inspector_email_id
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = var.inspector_email_id
}

resource "aws_sns_topic_policy" "this" {
  arn = aws_sns_topic.this.arn

  policy = jsonencode({
    "Version" : "2008-10-17",
    "Id" : "__default_policy_ID",
    "Statement" : [
      {
        "Sid" : "_default_statement",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "*"
        },
        "Action" : [
          "SNS:SetTopicAttributes",
          "SNS:ListSubscriptionsByTopic",
          "SNS:GetTopicAttributes"
        ],
        "Resource" : "arn:aws:sns:*:${var.account_id}:${var.sns_topic_name}",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceOwner" : "${var.account_id}"
          }
        }
      },
      {
        "Sid" : "_publish",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::316112463485:root"
        },
        "Action" : "SNS:Publish",
        "Resource" : "arn:aws:sns:*:${var.account_id}:${var.sns_topic_name}"
      },
      {
        "Sid" : "_subscribe",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${var.account_id}:root"
        },
        "Action" : "SNS:Subscribe",
        "Resource" : "arn:aws:sns:*:${var.account_id}:${var.sns_topic_name}"
      }
    ]
  })
}



################################################################################
# PARAMETER STORE AMI PIPELINE VARIABLES
################################################################################
resource "aws_ssm_parameter" "email_contact" {
  name  = "/codebuild/awsinspector/email_contact"
  type  = "String"
  value = var.inspector_email_id
}

resource "aws_ssm_parameter" "template_arn" {
  name  = "/codebuild/awsinspector/template_arn"
  type  = "String"
  value = aws_inspector_assessment_template.this.arn
}

resource "aws_ssm_parameter" "target_arn" {
  name  = "/codebuild/awsinspector/target_arn"
  type  = "String"
  value = aws_inspector_assessment_target.this.arn
}

