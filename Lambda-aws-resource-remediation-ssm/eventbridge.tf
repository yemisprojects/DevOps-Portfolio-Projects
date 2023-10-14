######################## EVENTBRIDGE RULE ########################
resource "aws_cloudwatch_event_rule" "lambda_notification_rule" {
  name          = "config-compliance-notification"
  description   = "Triggers Lambda when a resource is remediated to send email"
  is_enabled    = true
  event_pattern = <<EOF
{
   "source":[
      "aws.config"
   ],
   "detail-type":[
      "Config Rules Compliance Change"
   ],
   "detail":{
    "configRuleName": ["${local.config_rule_name}"],
      "messageType":[
         "ComplianceChangeNotification"
      ],
      "newEvaluationResult":{
         "complianceType":[
            "COMPLIANT"
         ]
      },
      "oldEvaluationResult":{
         "complianceType":[
            "NON_COMPLIANT"
         ]
      },
      "resourceType":[
        "AWS::SQS::Queue"
      ]
   }
}
EOF
}

######################## EVENTBRIDGE TARGET ####################################
resource "aws_cloudwatch_event_target" "lambda" {
  depends_on = [aws_lambda_function.lambda_mailer]
  rule       = aws_cloudwatch_event_rule.lambda_notification_rule.name
  target_id  = "SendToLambdaMailer"
  arn        = aws_lambda_function.lambda_mailer.arn
}

######################## EVENTBRIDGE LAMBDA PERMISSION ########################
resource "aws_lambda_permission" "event_brige_lambda_permission" {
  depends_on    = [aws_lambda_function.lambda_mailer]
  statement_id  = "AllowExecutionFromEventBridgeRule"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_mailer_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_notification_rule.arn
}