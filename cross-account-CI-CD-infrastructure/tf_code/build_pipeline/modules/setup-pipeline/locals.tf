locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}

locals {
  ami_pipeline_arn      = var.pipeline_type == "ami-pipeline" ? aws_codepipeline.golden_ami[0].arn : null
  prod_pipeline_arn     = var.pipeline_type == "prod-infra" ? aws_codepipeline.prod_infra_pipeline[0].arn : null
  non_prod_pipeline_arn = var.pipeline_type == "nonprod-infra" ? aws_codepipeline.non_prod_infra[0].arn : null

  pipeline_arn = { "ami-pipeline" = "${local.ami_pipeline_arn}"
    "prod-infra"    = "${local.prod_pipeline_arn}"
    "nonprod-infra" = "${local.non_prod_pipeline_arn}"
  }

  codepipeline_id = random_integer.this["codepipeline"].id
}
