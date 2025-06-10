# Ubuntu Image Builder and EC2 Deployment

This project automates the creation of a custom Ubuntu AMI using Packer, deploys an EC2 instance with Terraform, and enables SSH access via a VPN setup. The goal is to build a secure, scalable infrastructure for hosting applications like Nginx, with monitoring capabilities.

## Project Overview

- **Packer**: Creates a custom AMI from the Ubuntu 22.04 (Jammy) Cloud Image, pre-configured with Nginx and OpenVPN client tools.
- **Terraform**: Deploys an EC2 instance using the Packer-generated AMI and sets up a VPN host for secure SSH access.

## Prerequisites

- **AWS Account**: With credentials configured (`aws configure`) and permissions for EC2, S3, and VPC.
- **AWS CLI**: Installed locally (`sudo apt install awscli`).
- **Packer**: Installed (`brew install packer` or download from [packer.io](https://www.packer.io/downloads)).
- **Terraform**: Installed (`brew install terraform` or download from [terraform.io](https://www.terraform.io/downloads.html)).
- **SSH Key Pair**: Created in AWS (e.g., `your-key-name`) and downloaded locally.

## Setup Instructions

### 1. Initialize and Build the AMI with Packer

Packer creates a custom Ubuntu 22.04 AMI with Nginx and OpenVPN client pre-installed.

#### Configuration
- File: `ubuntu.pkr.hcl`
- Key Settings:
  - `source`: For me i used Ubuntu 18.04 AMI (e.g., `ami-0a1b37d39fbc96e30`).
  - `instance_type`: `t2.micro` (Nitro-based for UEFI compatibility).
  - `provisioner "shell"`: Installs Nginx or any tool.
