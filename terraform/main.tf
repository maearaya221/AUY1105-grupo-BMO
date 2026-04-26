# -------------------------
# VPC
# -------------------------
resource "aws_vpc" "AUY1105-duocapp-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "AUY1105-duocapp-vpc"
  }
}

# -------------------------
# Subnet publica
# -------------------------
resource "aws_subnet" "AUY1105-duocapp-subnet" {
  vpc_id                  = aws_vpc.AUY1105-duocapp-vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name = "AUY1105-duocapp-subnet"
  }
}

# -------------------------
# Internet Gateway
# -------------------------
resource "aws_internet_gateway" "AUY1105-duocapp-igw" {
  vpc_id = aws_vpc.AUY1105-duocapp-vpc.id

  tags = {
    Name = "AUY1105-duocapp-igw"
  }
}

# -------------------------
# Route Table
# -------------------------
resource "aws_route_table" "AUY1105-duocapp-rt" {
  vpc_id = aws_vpc.AUY1105-duocapp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.AUY1105-duocapp-igw.id
  }

  tags = {
    Name = "AUY1105-duocapp-rt"
  }
}

# -------------------------
# Route Table Association
# -------------------------
resource "aws_route_table_association" "AUY1105-duocapp-rta" {
  subnet_id      = aws_subnet.AUY1105-duocapp-subnet.id
  route_table_id = aws_route_table.AUY1105-duocapp-rt.id
}

# -------------------------
# Security Group
# -------------------------
resource "aws_security_group" "AUY1105-duocapp-sg" {
  name        = "AUY1105-duocapp-sg"
  description = "Security group que permite SSH entrante y todo el trafico saliente"
  vpc_id      = aws_vpc.AUY1105-duocapp-vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  egress {
    description = "Todo el trafico saliente permitido"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AUY1105-duocapp-sg"
  }
}

# -------------------------
# EC2 Instance
# -------------------------
resource "aws_instance" "AUY1105-duocapp-ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.AUY1105-duocapp-subnet.id
  vpc_security_group_ids = [aws_security_group.AUY1105-duocapp-sg.id]

  tags = {
    Name = "AUY1105-duocapp-ec2"
  }
}
