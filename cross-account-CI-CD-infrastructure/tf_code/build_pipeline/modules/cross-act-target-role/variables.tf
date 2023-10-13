variable "cross_act_role_name" {
  description = "Name of cross account IAM role to deploy infrastructure"
  type = string
  default = "Pipeline-Deploy-Infrastructure"
}

variable "cicd_act_no" {
  description = "CI/CD tooling Account number"
  type = string
}