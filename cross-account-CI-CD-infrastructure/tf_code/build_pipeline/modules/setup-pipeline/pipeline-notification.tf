################################################################################
# SNS MANUAL APPROVAL
################################################################################
resource "aws_sns_topic" "pipeline_approval" {
  # count = var.pipeline_type != "nonprod-infra" ? 1 : 0
  count = 1

  name = var.codepipeline_approval_sns_topic
}

resource "aws_sns_topic_subscription" "pipeline_approval" {
  # count = var.pipeline_type != "nonprod-infra" ? 1 : 0
  count = 1

  topic_arn = aws_sns_topic.pipeline_approval[0].arn
  protocol  = "email"
  endpoint  = var.pipeline_approval_email_id
}

resource "aws_sns_topic" "pipeline_status" {
  count = var.create_sns_notification_rule ? 1 : 0

  name = var.pipeline_status_sns_topic
}

resource "aws_sns_topic_subscription" "pipeline_status" {
  count = var.create_sns_notification_rule ? 1 : 0

  topic_arn = aws_sns_topic.pipeline_status[0].arn
  protocol  = "email"
  endpoint  = var.pipeline_status_email_id
}

resource "aws_codestarnotifications_notification_rule" "pipeline_status" {

  count = var.create_sns_notification_rule ? 1 : 0

  name        = "pipeline-status"
  detail_type = "FULL"
  event_type_ids = ["codepipeline-pipeline-pipeline-execution-failed",
    "codepipeline-pipeline-pipeline-execution-canceled",
    "codepipeline-pipeline-pipeline-execution-succeeded",
    "codepipeline-pipeline-manual-approval-needed",
    "codepipeline-pipeline-manual-approval-succeeded",
  "codepipeline-pipeline-manual-approval-failed"]

  resource = aws_codepipeline.prod_infra_pipeline[0].arn

  target {
    address = aws_sns_topic.pipeline_status[0].arn
  }
}