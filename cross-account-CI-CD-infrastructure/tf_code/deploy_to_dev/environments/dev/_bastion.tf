################################################################################
# JUMP BOX - Disabled by default
################################################################################
module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.2.1"

  count = var.create_bastion_host ? 1 : 0

  name                   = "Bastion-${var.env}"
  ami                    = data.aws_ssm_parameter.latest_ami.value
  instance_type          = var.instance_type
  # key_name               = var.key_name
  monitoring             = true
  vpc_security_group_ids = [module.bastion_sg[0].security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  depends_on = [module.vpc]
}

module "bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.16.2"

  count       = var.create_bastion_host ? 1 : 0
  name        = "bastion-sg-${var.env}"
  description = "Security group for Bastion to access Private EC2 instances"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = var.bastion_ingress_cidr_blocks
  ingress_rules       = ["ssh-tcp"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
}