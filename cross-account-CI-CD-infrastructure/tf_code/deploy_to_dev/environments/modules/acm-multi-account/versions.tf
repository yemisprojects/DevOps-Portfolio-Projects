terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.46"
      configuration_aliases = [ aws.dns_act_owner ]
    }
  }
}
