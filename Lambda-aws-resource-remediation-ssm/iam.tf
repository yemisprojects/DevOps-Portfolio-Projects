######################## SSM AUTOMATION ROLE ########################
resource "aws_iam_role" "automation_role" {
  name               = "sys-manager-automation-role"
  assume_role_policy = data.aws_iam_policy_document.automation_assume_role_policy.json
  inline_policy {
    name   = "AutomationPermissions"
    policy = data.aws_iam_policy_document.automation_inline_policy.json
  }
}

################## SSM AUTOMATION TRUST POLICY ##################
data "aws_iam_policy_document" "automation_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = ["${local.account_id}"]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:ssm:*:${local.account_id}:automation-execution/*"]
    }
  }
}

######### SSM AUTOMATION POLICY #########
data "aws_iam_policy_document" "automation_inline_policy" {
  statement {
    sid       = "RemediateSqsQueue"
    effect    = "Allow"
    actions   = ["sqs:SetQueueAttributes"]
    resources = ["arn:aws:sqs:${var.aws_region}:${local.account_id}:*"]
  }
  statement {
    sid       = "ReportFailedRemediation"
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = ["arn:aws:sns:${var.aws_region}:${local.account_id}:${local.sns_topic_name}"]
  }
  statement {
    sid    = "ExecuteAutomations"
    effect = "Allow"
    actions = ["ssm:StartAutomationExecution", "ssm:StopAutomationExecution"]
    resources = ["*"]
  }
}


//////////////////////////// LAMBDA E-MAILER ROLE ////////////////////////////
resource "aws_iam_role" "lambda_mailer_role" {
  name               = "lambda-mail-compliance_status-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_mailer_assume_role_policy.json
  inline_policy {
    name   = "LambdaFunctionPermissions"
    policy = data.aws_iam_policy_document.lambda_mailer_inline_policy.json
  }
}

################## LAMBDA E-MAILER TRUST POLICY ##################
data "aws_iam_policy_document" "lambda_mailer_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

######### LAMBDA E-MAILER POLICY #########
data "aws_iam_policy_document" "lambda_mailer_inline_policy" {
  statement {
    sid     = "CreateLogGroup"
    effect  = "Allow"
    actions = ["sqs:ListQueueTags", "logs:CreateLogGroup", "ses:SendEmail"]
    resources = ["arn:aws:logs:${var.aws_region}:*:log-group:*",
      "arn:aws:sqs:${var.aws_region}:${local.account_id}:*",
    "arn:aws:ses:${var.aws_region}:${local.account_id}:identity/*"]
  }

  statement {
    sid       = "CreateLogStreamsAndWriteEventLogs"
    effect    = "Allow"
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.lambda_mailer.arn}:*"]
  }
}

//////////////////////////// LAMBDA EVALUATOR ROLE ////////////////////////////
resource "aws_iam_role" "lambda_evaluator_role" {
  name               = "lambda-compliance-evaluator-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_evaluator_assume_role_policy.json
  inline_policy {
    name   = "LambdaFunctionPermissions"
    policy = data.aws_iam_policy_document.lambda_evaluator_inline_policy.json
  }
}

################## LAMBDA EVALUATOR TRUST POLICY ##################
data "aws_iam_policy_document" "lambda_evaluator_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

######### LAMBDA EVALUATOR POLICY #########
data "aws_iam_policy_document" "lambda_evaluator_inline_policy" {
  statement {
    sid       = "AllowConfigRuleUpdate"
    effect    = "Allow"
    actions   = ["config:PutEvaluations"]
    resources = ["*"]
  }
  statement {
    sid     = "AllowLambdaCreateLogGroup"
    effect  = "Allow"
    actions = ["sqs:GetQueueAttributes", "logs:CreateLogGroup"]
    resources = ["arn:aws:logs:${var.aws_region}:*:log-group:*",
    "arn:aws:sqs:${var.aws_region}:${local.account_id}:*"]
  }
  statement {
    sid       = "AllowLambdaCreateLogStreamsAndWriteEventLogs"
    effect    = "Allow"
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.lambda_evaluator.arn}:*"]
  }
}

