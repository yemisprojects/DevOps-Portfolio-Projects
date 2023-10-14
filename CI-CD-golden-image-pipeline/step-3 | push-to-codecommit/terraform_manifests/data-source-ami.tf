data "aws_ami" "packer_image" {
  most_recent = true

  filter {
    name   = "tag:CreatedBy"
    values = ["Packer"]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.app_name}-*"]
  }

  owners = ["self"]
}


/* data "aws_ami" "packer_image" {
  most_recent = true

  filter {
    name   = "tag:CreatedBy"
    values = ["Packer"]
  }

  filter {
    name   = "tag:Name"
    values = ["amazon-linux-2-hvm-java-login-*"]
  }

  owners = ["self"]
}
 */