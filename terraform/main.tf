terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0.0"
}


provider "aws" {
  region = "us-east-1"
}


# Create a VPC with private and public subnets
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  # Enable DNS hostnames for public subnets
  enable_dns_hostnames = true
}

data "http" "my_ip" {
  url = "https://ifconfig.me/ip"
}

# Security group allowing SSH access
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH trafic from my IP only"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}


data "aws_ami" "ubuntu" {
  most_recent = true
  name_regex = "ubuntu-image-builder-*"
  owners = ["self"]
}


resource "aws_instance" "ubuntu" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]


  key_name = "ubuntu-project"
  
  associate_public_ip_address = true

  tags = {
    Name = "ubuntu-image-builder"
  }
              
              
}


output "instance_public_ip" {
  value = aws_instance.ubuntu.public_ip
}





