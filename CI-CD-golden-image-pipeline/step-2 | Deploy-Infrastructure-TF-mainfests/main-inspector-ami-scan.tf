###############################################################################
# CREATE AMI-PIPELINE AND TRIGGER WITH GIT PUSH on MAIN BRANCH
################################################################################
module "inspector_ec2_instance" {
  source = "../modules/inspector-scan"

  inspector_email_id = var.inspector_email_id
  account_id         = data.aws_caller_identity.inspector.account_id
  duration           = var.scan_duration

}

###############################################################################
# SUPPORTING RESOURCE
################################################################################
data "aws_caller_identity" "inspector" {
}
