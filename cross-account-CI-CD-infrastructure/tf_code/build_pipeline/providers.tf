provider "aws" {
  alias   = "cicd_act"
  region  = var.aws_region
  profile = var.cicd_act_profile
}

provider "aws" {
  alias   = "dev_env"
  region  = var.aws_region
  profile = var.dev_act_profile
}























/* provider "aws" {
  alias   = "prod_env"
  region  = var.aws_region
  profile = var.prod_act_profile
} */

