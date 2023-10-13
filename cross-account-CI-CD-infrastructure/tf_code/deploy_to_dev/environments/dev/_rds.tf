################################################################################
# RDS
################################################################################
module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.2.1"

  create_db_instance        = true
  create_db_parameter_group = true
  create_db_option_group    = true

  identifier = "${var.db_identifier}-${var.env}"

  engine               = "mysql"
  engine_version       = "8.0.34"
  family               = "mysql8.0"
  major_engine_version = "8.0"
  instance_class       = var.db_instance_class

  allocated_storage     = 20
  max_allocated_storage = 100

  db_name                = var.db_name
  username               = local.db_username
  password               = local.db_password
  create_random_password = false
  port                   = 3306

  multi_az               = false
  subnet_ids             = module.vpc.database_subnets
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  vpc_security_group_ids = [module.rds_sg.security_group_id]

  enabled_cloudwatch_logs_exports = ["general"]
  create_cloudwatch_log_group     = true

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  create_monitoring_role = true
  monitoring_interval    = 60

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  tags = {
    "project" = "test"
  }

  depends_on = [module.vpc]

}

################################################################################
# RDS SecurityGroup
################################################################################
module "rds_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.16.2"

  name        = "rds-sg-${var.env}"
  description = "Security group for RDS database in private subnet"
  vpc_id      = module.vpc.vpc_id


  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]
  ingress_rules       = ["mysql-tcp"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
}

################################################################################
# RDS CREDENTIALS
################################################################################
resource "aws_secretsmanager_secret" "rds_creds" {
  name_prefix = "my-rds-credentials"
}

resource "aws_secretsmanager_secret_version" "rds_creds" {
  secret_id     = aws_secretsmanager_secret.rds_creds.id
  secret_string = <<EOF
   {
    "username": "${local.db_username}",
    "password": "${local.db_password}"
   }
EOF
}

################################################################################
# SUPPORTING RESOURCES
################################################################################
resource "random_password" "db" {
  length  = 16
  special = false
  keepers = {
    password_version = 1
  }
}

resource "random_integer" "db_user" {
  min = 1000
  max = 9999

  keepers = {
    user_renew = "a"
  }
}