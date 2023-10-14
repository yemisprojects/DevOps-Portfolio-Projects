locals {
    common_tags = {
      Project     = "ami-pipeline"
      CreatedBy   = "terraform"
    }
}

################################################################################
# VPC
################################################################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name            = "vpc-${var.env}"
  cidr            = var.cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = var.public_subnet_tags

  tags = local.common_tags

}

################################################################################
# EC2
################################################################################
module "ec2_inspector" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.3.0"

  name                   = "inspector-goldenami-${var.env}"
  ami                    = data.aws_ami.packer_image.image_id
  instance_type          = var.instance_type
  availability_zone      = var.azs[0]
  monitoring             = true
  vpc_security_group_ids = [module.this.security_group_id]
  subnet_id              = element(module.vpc.private_subnets, 0)
  user_data              = templatefile("${path.module}/script/install.sh", {})

  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    SSMAccess = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  tags = merge( local.common_tags,
                  {
                    "AwsInspectorScan" = "True"
                    "Environment"      = var.env
                  }
              )

  depends_on = [module.vpc]
}

################################################################################
# SECURITY-GROUP
################################################################################
module "this" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.16.2"

  name        = "inspector-${var.env}"
  description = "Security group for AWS inspector test instance"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [var.cidr]
  ingress_rules       = ["ssh-tcp"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]

  tags = local.common_tags
}
