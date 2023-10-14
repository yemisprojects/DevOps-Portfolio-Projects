variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "vpc_cidr" {
  type = string
  default = "172.17.0.0/16"
}

variable "region" {
  type = string 
  default = "us-east-1"
}

variable "app_name" {
  type    = string
  default = "java-app"
}
