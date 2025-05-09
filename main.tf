provider "aws" {
  region = "ap-south-1"
}

# VPC
resource "aws_vpc" "business_vpc" {
  for_each = var.businesses

  cidr_block = each.value.vpc_cidr

  tags = {
    Name = "${each.key}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  for_each = var.businesses

  vpc_id = aws_vpc.business_vpc[each.key].id

  tags = {
    Name = "${each.key}-igw"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  for_each = var.businesses

  vpc_id                  = aws_vpc.business_vpc[each.key].id
  cidr_block              = each.value.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "${each.key}-public-subnet"
  }
}

# Route Table
resource "aws_route_table" "public_rt" {
  for_each = var.businesses

  vpc_id = aws_vpc.business_vpc[each.key].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[each.key].id
  }

  tags = {
    Name = "${each.key}-public-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "public_subnet_association" {
  for_each = var.businesses

  subnet_id      = aws_subnet.public_subnet[each.key].id
  route_table_id = aws_route_table.public_rt[each.key].id
}

# Security Group
resource "aws_security_group" "business_sg" {
  for_each = var.businesses

  name        = "${each.key}-sg"
  description = "Allow SSH, HTTP, and HTTPS"
  vpc_id      = aws_vpc.business_vpc[each.key].id

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

  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "${each.key}-security-group"
  }
}
