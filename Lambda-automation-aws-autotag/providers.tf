########## PLUGINS and TF VERSION ##########
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.30.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.3.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = "~> 1.0"
}

########## REGION OF DEPLOYMENT ##########
provider "aws" {
  region  = var.aws_region
  
  default_tags {
    tags = {
      Environment = "Dev"
      Project     = "Auto_tag"
    }
  }
}