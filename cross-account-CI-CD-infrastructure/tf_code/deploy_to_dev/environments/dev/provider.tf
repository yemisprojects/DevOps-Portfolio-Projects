provider "aws" {
  region  = var.aws_region

  assume_role {
    role_arn = var.cross_account_role
    session_name = "Build_Infra_in_dev_from_tooling_CICD"
  }
}