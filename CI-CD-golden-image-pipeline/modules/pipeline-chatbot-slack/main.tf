################################################################################
# CODEPIPELINE NOTIFICATION RULE
################################################################################
resource "aws_codestarnotifications_notification_rule" "pipeline_status" {

  for_each = var.notification_rules_config

  name           = each.value.notification_rule_name
  detail_type    = each.value.detail_type
  event_type_ids = each.value.event_type_ids
  resource       = each.value.pipeline_arn

  target {
    address = aws_cloudformation_stack.chatbot_slack_configuration.outputs.ConfigurationArn
    type    = "AWSChatbotSlack"
  }
}

################################################################################
# CFN RESOURCE: sns topic is autocreated for chatbot-pipeline integration
################################################################################
resource "aws_cloudformation_stack" "chatbot_slack_configuration" {
  name = "chatbot-slack-configuration-${var.configuration_name}"

  template_body = data.local_file.cloudformation_template.content

  parameters = {
    ConfigurationNameParameter = var.configuration_name
    GuardrailPoliciesParameter = join(",", var.guardrail_policies)
    IamRoleArnParameter        = "${aws_iam_role.chatbot.arn}"
    LoggingLevelParameter      = var.logging_level
    SlackChannelIdParameter    = var.slack_channel_id
    SlackWorkspaceIdParameter  = var.slack_workspace_id
    # SnsTopicArnsParameter      = join(",", ["${aws_sns_topic.pipeline_status.arn}"])  #join(",", var.sns_topic_arns)
    # UserRoleRequiredParameter  = var.user_role_required
  }

  tags = var.tags
}

data "local_file" "cloudformation_template" {
  filename = "${path.module}/cloudformation.yml"
}

################################################################################
# CHATBOT ROLE
################################################################################
resource "aws_iam_role" "chatbot" {
  name = "chatbot-slack-role"
  managed_policy_arns = ["arn:aws:iam::aws:policy/AWSSupportAccess",
  "arn:aws:iam::aws:policy/ReadOnlyAccess"]
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "chatbot.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_invoke" {
  name   = "AWS-Chatbot-LambdaInvoke-Policy"
  role   = aws_iam_role.chatbot.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "lambda:invokeAsync",
                "lambda:invokeFunction"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "notifications_only" {
  name   = "AWS-Chatbot-NotificationsOnly-Policy"
  role   = aws_iam_role.chatbot.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "cloudwatch:Describe*",
                "cloudwatch:Get*",
                "cloudwatch:List*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "read_commands" {
  name   = "AWS-Chatbot-ReadonlyCommands-Policy"
  role   = aws_iam_role.chatbot.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Action": [
                "iam:*",
                "s3:GetBucketPolicy",
                "ssm:*",
                "sts:*",
                "kms:*",
                "cognito-idp:GetSigningCertificate",
                "ec2:GetPasswordData",
                "ecr:GetAuthorizationToken",
                "gamelift:RequestUploadCredentials",
                "gamelift:GetInstanceAccess",
                "lightsail:DownloadDefaultKeyPair",
                "lightsail:GetInstanceAccessDetails",
                "lightsail:GetKeyPair",
                "lightsail:GetKeyPairs",
                "redshift:GetClusterCredentials",
                "storagegateway:DescribeChapCredentials"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}



