provider "aws" {
  region     = "ap-south-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Get Default VPC
data "aws_vpc" "default" {
  default = true
}

# Security Group: My_EC2-SG
resource "aws_security_group" "ec2_sg" {
  name        = "My_EC2-SG"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "My_EC2-SG"
  }
}

# EC2 Instance with Apache Installed
resource "aws_instance" "my_ec2" {
  ami                    = "ami-0e35ddab05955cf57"
  instance_type          = "t2.micro"
  vpc
