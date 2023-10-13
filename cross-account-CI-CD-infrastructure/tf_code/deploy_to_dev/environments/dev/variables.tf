################################################################################
# GENERAL
################################################################################
variable "aws_region" {
  description = "Region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Environment"
  type        = string
}

variable "cross_account_role" {
  description = "Deployment role used by CI/CD pipeline"
  type = string
}

################################################################################
# VPC
################################################################################
variable "cidr" {
  description = "The IPv4 CIDR block for the VPC"
  type        = string
  default     = "172.16.0.0/16"
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
}

variable "database_subnets" {
  description = "A list of database subnets"
  type        = list(string)
}

################################################################################
# EC2
################################################################################
variable "create_bastion_host" {
  description = "Choose true if a bastion host should be created in a public subnet"
  type        = bool
  default     = false
}

#t2.micro causes "requested configuration is currently not supported" with current config
variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}

# variable "key_name" {
#   description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
#   type        = string
# }

variable "bastion_ingress_cidr_blocks" {
  description = "Ingress cidr blocks allowed to bastion host"
  type        = list(string)
  default     = ["127.0.0.1/32"]
}

################################################################################
# ROUTE53
################################################################################
variable "route53_zone_name" {
  description = "name of the hosted zone"
  type        = string
  default     = "example.com"
}

################################################################################
# ACM
################################################################################
variable "subject_alternative_names" {
  description = "A list of domains that should be SANs in the issued certificate"
  type        = list(string)
  default     = ["www.example.com", "app.example.com"]
}

################################################################################
# RDS
################################################################################
variable "db_identifier" {
  description = "The name of the RDS instance"
  type        = string
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.large"
}

variable "db_name" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
}

################################################################################
# ALERTING EMAIL 
################################################################################
variable "sns_subscription_email" {
  description = "Email for receiving asg and CW alarm notifications"
  type        = string
  default     = "example@gmail.com"
}
