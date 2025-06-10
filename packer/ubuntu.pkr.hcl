packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "ubuntu" {

  ami_name = "ubuntu-image-builder-${local.timestamp}"
  source_ami = "ami-0fea31578248bcd6c"
  instance_type = "t2.micro"
  region = "us-east-1"
  ssh_username = "ubuntu"
  
}

build {
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    script = "./scripts/nginx.sh"
  }
}
