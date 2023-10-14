################################################################################
# DEPLOY CROSS-ACT ROLE TO DEV ENV
################################################################################
module "dev_cross_act_role" {
  source = "./modules/cross-act-target-role"
  providers = {
    aws = aws.dev_env
  }

  cicd_act_no = var.cicd_act_no
}

/* This dev_cross_act_role module deploys a cross account IAM role in the dev account used by 
code pipeline to build our infrastructure*/







































/* module "prod_cross_act_role" {
  source = "./modules/cross-act-target-role"
  providers = {
    aws = aws.prod_env 
   }

   cicd_act_no = var.cicd_act_no
}
 */