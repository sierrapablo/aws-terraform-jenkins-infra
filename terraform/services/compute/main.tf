# Configure AWS Provider
provider "aws" {
  region  = "eu-west-1"
  profile = "sierrapablo"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.13.4"
}

# ---------------------------------------------------------------------------- #

# Fetch the default VPC
data "aws_vpc" "default" {
  default = true
}

# Security group for SSH and ICMP (ping)
resource "aws_security_group" "tiny_ec2_sg" {
  name        = "${var.instance_name}-sg"
  description = "Allow SSH and ICMP access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
  }

  ingress {
    description = "Allow ICMP (ping)"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.allowed_ssh_cidrs
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.instance_name}-sg"
    Environment = var.env
  }
}

# Automatically fetch the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

# Launch the smallest free-tier EC2 instance
resource "aws_instance" "tiny_ec2" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.tiny_ec2_sg.id]
  associate_public_ip_address = true

  tags = {
    Name        = var.instance_name
    Environment = var.env
  }
}
