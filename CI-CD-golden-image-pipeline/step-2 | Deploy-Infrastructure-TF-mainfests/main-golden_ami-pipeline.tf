###############################################################################
# CREATE AMI-PIPELINE AND TRIGGER WITH GIT PUSH on MAIN BRANCH
################################################################################
module "golden_ami_pipeline" {
  source = "../modules/setup-pipeline"

  pipeline_type              = "ami-pipeline"
  repo_name                  = var.ami_repo_name
  deploy_stage_name          = var.ami_deploy_stage_name
  codepipeline_name          = var.ami_codepipeline_name
  pipeline_approval_email_id = var.pipeline_approval_email_id

  cb_project_configs = {
    "create_ami" = {
      project_name   = "packer_create_ami"
      buildspec_path = "buildspec-packer.yml"
    },
    "scan_ami" = {
      project_name   = "inspector_scan_ami"
      buildspec_path = "buildspec-inspector.yml"
    },
    "share_ami" = {
      project_name   = "share_ami_acts"
      buildspec_path = "buildspec-share_ami.yml"
    }
  }
}
