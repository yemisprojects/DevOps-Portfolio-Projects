locals {
  ami_pattern   = var.pipeline_type == "ami-pipeline" ? data.template_file.ami_pipeline[0].rendered : null
  infra_pattern = var.pipeline_type != "ami-pipeline" ? data.template_file.infra_pipeline[0].rendered : null
  event_pattern = var.pipeline_type == "ami-pipeline" ? local.ami_pattern : local.infra_pattern

  event_bridge_id = random_integer.this["eventbridge"].id
}

resource "random_integer" "this" {

  for_each = toset(["eventbridge", "codebuild", "codepipeline"])

  min = 100000000000
  max = 999999999999
}

################################################################################
# DIFFERENT RULE PATTERNS
################################################################################
/*data "template_file" "infra_pipeline" {
  count = var.pipeline_type != "ami-pipeline" ? 1 : 0

  template = file("${path.module}/templates/event_bridge_rule.tftpl")
  vars = {
    repo_arn = "${aws_codecommit_repository.this.arn}",
    ref_type = "tag",
    ref_name = jsonencode([{ "suffix" : "${var.git_tag_trigger}" }])
  }
}*/

data "template_file" "infra_pipeline" {
  count = var.pipeline_type != "ami-pipeline" ? 1 : 0

  template = file("${path.module}/templates/event_bridge_rule.tftpl")
  vars = {
    repo_arn = "${aws_codecommit_repository.this.arn}",
    ref_type = "branch",
    ref_name = jsonencode(["${var.branch_name}", "main"])
  }
}

data "template_file" "ami_pipeline" {
  count = var.pipeline_type == "ami-pipeline" ? 1 : 0

  template = file("${path.module}/templates/event_bridge_rule.tftpl")
  vars = {
    repo_arn = "${aws_codecommit_repository.this.arn}",
    ref_type = "branch",
    ref_name = jsonencode(["${var.branch_name}", "master"])
  }
}

################################################################################
# EVENTBRIDGE RULE
################################################################################
resource "aws_cloudwatch_event_rule" "pipeline" {
  name        = "${var.pipeline_type}-${local.event_bridge_id}"
  description = "Amazon CloudWatch Events rule to automatically start your pipeline when a change occurs in the AWS CodeCommit source repository and branch"

  event_pattern = local.event_pattern
  tags          = var.event_bridge_rule_tags
}

resource "aws_cloudwatch_event_target" "pipeline" {
  rule      = aws_cloudwatch_event_rule.pipeline.name
  target_id = "StartPipeline"
  arn       = lookup(local.pipeline_arn, var.pipeline_type)
  role_arn  = aws_iam_role.event_bridge.arn
}

################################################################################
# EVENTBRIDGE IAM ROLE
################################################################################
resource "aws_iam_role" "event_bridge" {

  name               = "eventbrige-${var.pipeline_type}-${local.event_bridge_id}"
  description        = "Used by eventbridge to start pipeline"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

#update * to codepiple arn
resource "aws_iam_role_policy" "event_bridge" {

  name = "start-pipeline"
  role = aws_iam_role.event_bridge.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "StartPipeline",
        "Effect" : "Allow",
        "Action" : ["codepipeline:StartPipelineExecution"],
        "Resource" : "*"
      }
    ]
  })
}







/* resource "aws_cloudwatch_event_rule" "pipeline" {
  name        = var.event_bridge_rule_name
  description = "Amazon CloudWatch Events rule to automatically start your pipeline when a change occurs in the AWS CodeCommit source repository and branch"

  event_pattern = <<EOF
{
  "source": ["aws.codecommit"],
  "detail-type": ["CodeCommit Repository State Change"],
  "resources": ["${aws_codecommit_repository.this.arn}"],
  "detail": {
    "event": ["referenceCreated", "referenceUpdated"],
    "referenceType": ["branch"],
    "referenceName": ["${var.branch_name}", "main"]
  }
}
EOF

  tags = var.event_bridge_rule_tags
} */

/* resource "aws_cloudwatch_event_rule" "pipeline" {
  name        = var.event_bridge_rule_name
  description = "Amazon CloudWatch Events rule to automatically start your pipeline when a change occurs in the AWS CodeCommit source repository and branch"

  event_pattern = <<EOF
{
  "source": ["aws.codecommit"],
  "detail-type": ["CodeCommit Repository State Change"],
  "resources": ["${aws_codecommit_repository.this.arn}"],
  "detail": {
    "event": ["referenceCreated", "referenceUpdated"],
    "referenceType": ["tag"],
    "referenceName": [{ "suffix": "${var.git_tag_trigger}" }]
  }
}
EOF

  tags = var.event_bridge_rule_tags
} */
