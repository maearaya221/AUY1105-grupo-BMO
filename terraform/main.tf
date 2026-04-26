resource "aws_vpc" "AUY1105-duocapp-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "AUY1105-duocapp-vpc"
  }
}

resource "aws_default_security_group" "AUY1105-duocapp-default-sg" {
  vpc_id = aws_vpc.AUY1105-duocapp-vpc.id

  tags = {
    Name = "AUY1105-duocapp-default-sg"
  }
}

resource "aws_cloudwatch_log_group" "AUY1105-duocapp-lg" {
  name              = "/aws/vpc/AUY1105-duocapp-flowlogs"
  retention_in_days = 7

  tags = {
    Name = "AUY1105-duocapp-lg"
  }
}

resource "aws_iam_role" "AUY1105-duocapp-flowlogs-role" {
  name = "AUY1105-duocapp-flowlogs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "AUY1105-duocapp-flowlogs-role"
  }
}

resource "aws_iam_role_policy" "AUY1105-duocapp-flowlogs-policy" {
  name = "AUY1105-duocapp-flowlogs-policy"
  role = aws_iam_role.AUY1105-duocapp-flowlogs-role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_flow_log" "AUY1105-duocapp-flowlog" {
  vpc_id          = aws_vpc.AUY1105-duocapp-vpc.id
  traffic_type    = "ALL"
  iam_role_arn    = aws_iam_role.AUY1105-duocapp-flowlogs-role.arn
  log_destination = aws_cloudwatch_log_group.AUY1105-duocapp-lg.arn

  tags = {
    Name = "AUY1105-duocapp-flowlog"
  }
}

resource "aws_subnet" "AUY1105-duocapp-subnet" {
  vpc_id                  = aws_vpc.AUY1105-duocapp-vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = false
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name = "AUY1105-duocapp-subnet"
  }
}

resource "aws_internet_gateway" "AUY1105-duocapp-igw" {
  vpc_id = aws_vpc.AUY1105-duocapp-vpc.id

  tags = {
    Name = "AUY1105-duocapp-igw"
  }
}

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

resource "aws_route_table_association" "AUY1105-duocapp-rta" {
  subnet_id      = aws_subnet.AUY1105-duocapp-subnet.id
  route_table_id = aws_route_table.AUY1105-duocapp-rt.id
}

resource "aws_security_group" "AUY1105-duocapp-sg" {
  name        = "AUY1105-duocapp-sg"
  description = "Security group que permite SSH entrante restringido y trafico saliente controlado"
  vpc_id      = aws_vpc.AUY1105-duocapp-vpc.id

  ingress {
    description = "SSH restringido a CIDR especifico"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  egress {
    description = "Trafico saliente HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Trafico saliente HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AUY1105-duocapp-sg"
  }
}

resource "aws_iam_role" "AUY1105-duocapp-ec2-role" {
  name = "AUY1105-duocapp-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "AUY1105-duocapp-ec2-role"
  }
}

resource "aws_iam_instance_profile" "AUY1105-duocapp-ec2-profile" {
  name = "AUY1105-duocapp-ec2-profile"
  role = aws_iam_role.AUY1105-duocapp-ec2-role.name

  tags = {
    Name = "AUY1105-duocapp-ec2-profile"
  }
}

resource "aws_instance" "AUY1105-duocapp-ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.AUY1105-duocapp-subnet.id
  vpc_security_group_ids = [aws_security_group.AUY1105-duocapp-sg.id]
  iam_instance_profile   = aws_iam_instance_profile.AUY1105-duocapp-ec2-profile.name
  monitoring             = true
  ebs_optimized          = true

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "AUY1105-duocapp-ec2"
  }
}
