############ EVENTBRIDGE RULE ############
resource "aws_cloudwatch_event_rule" "sns_event_rule" {
  name          = "rule-sns-topics"
  description   = "Triggers Lambda when new sns topics are created"
  is_enabled    = true
  event_pattern = <<EOF
    {
    "detail-type": ["AWS API Call via CloudTrail"],
    "detail": {
        "eventSource" : ["sns.amazonaws.com"],
        "eventName": ["CreateTopic"]
    }
    }
  EOF
}

############ EVENTBRIDGE TARGET ############
resource "aws_cloudwatch_event_target" "lambda" {
  depends_on = [aws_lambda_function.autotag]
  rule       = aws_cloudwatch_event_rule.sns_event_rule.name
  target_id  = "SendToLambda"
  arn        = aws_lambda_function.autotag.arn
}

resource "aws_lambda_permission" "event_brige_rule" {
  depends_on    = [aws_lambda_function.autotag]
  statement_id  = "AllowExecutionFromEventBridgeRule"
  action        = "lambda:InvokeFunction"
  function_name = var.autotag_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.sns_event_rule.arn
}

