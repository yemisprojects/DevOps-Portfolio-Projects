################################################################################
# REMOTE BACKEND FOR MAIN INFRASTRUCTURE
################################################################################
module "main_backend" {
  source = "../modules/setup-backend"

  table_name  = "main-infra-tfstate-lock"
  bucket_name = "main-infra-tfstate-${random_integer.this.id}"
}

resource "random_integer" "this" {
  min = 100000000000
  max = 999999999999
}

###############################################################################
# REMOTE BACKEND FOR RESOURCES CREATED WITHIN PIPELINE
################################################################################
module "pipeline_backend" {
  source = "../modules/setup-backend"

  table_name  = "ami-pipeline-tfstate-db-lock"
  bucket_name = "ami-pipeline-tfstate-s3-${random_integer.gami.id}"
}

resource "random_integer" "gami" {
  min = 1000000000
  max = 9999999999
}
