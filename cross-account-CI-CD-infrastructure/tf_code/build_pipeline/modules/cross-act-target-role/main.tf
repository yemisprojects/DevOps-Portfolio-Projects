resource "aws_iam_role" "cross_act" {

  name                = var.cross_act_role_name
  description         = "Used by codebuild to deploy infrastructure"
  path                = "/"
  assume_role_policy  = data.aws_iam_policy_document.assume_role.json
}

#update to role specific and not account wide trust
data "aws_iam_policy_document" "assume_role" {

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.cicd_act_no]
    }
  }
}

resource "aws_iam_role_policy" "deploy_infra" {

  name = "Deploy-infrastructure"
  role = aws_iam_role.cross_act.id

  #permissions should be least priviledge, AdminAccess used for simplicity
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Deploy3Tier",
            "Effect": "Allow",
            "Action": [
                "rds:*",
                "s3:*",
                "cloudwatch:*",
                "wafv2:*",
                "logs:*",
                "route53:*",
                "ec2:*",
                "elasticloadbalancing:*",
                "autoscaling:*",
                "acm:*",
                "iam:*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AdminAccess",
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
})
} 

