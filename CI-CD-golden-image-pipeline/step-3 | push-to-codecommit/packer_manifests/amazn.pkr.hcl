locals {
  ami_name  = "${var.app_name}-${local.timestamp}"
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

data "amazon-parameterstore" "base_ami" {
  name            = "/aws/service/ami-amazon-linux-latest/amzn2-ami-kernel-5.10-hvm-x86_64-gp2"
  with_decryption = false
}

source "amazon-ebs" "app" {
  source_ami    = data.amazon-parameterstore.base_ami.value
  ami_description = "Ami for java web app"
  ami_name      = local.ami_name
  instance_type = var.instance_type
  region        = var.region
  ssh_username  = "ec2-user"
  # ami_users = ["1111111111111"]

  vpc_filter {
    filters = {
      "tag:Project": "ami-pipeline",
      "tag:CreatedBy": "terraform",
      "isDefault": "false",
      "cidr": "${var.vpc_cidr}"
    }
  }

  subnet_filter {
    filters = {
      "tag:Project": "ami-pipeline",
      "tag:subnet_type": "public_subnet",
      "tag:CreatedBy": "terraform"
    }
    most_free = true
    random = false
  }

  tags = {
    CreatedBy = "Packer"
    Name      = local.ami_name
    app       = var.app_name
  }
}

build {
  sources = ["source.amazon-ebs.app"]

  provisioner "shell" {
    script      = "scripts/install_app.sh"
    remote_file = "install_app.sh"
  }

  provisioner "file" {
    destination = "/home/ec2-user/app "
    source      = "files/usermgmt-webapp.war"
  }

  post-processor "manifest" {
    output     = "manifest.json"
  }
}