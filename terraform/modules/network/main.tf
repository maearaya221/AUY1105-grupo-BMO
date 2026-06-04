data "aws_caller_identity" "current" {}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "AUY1105-duocapp-vpc"
  }
}

resource "aws_default_security_group" "default_sg" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "AUY1105-duocapp-default-sg"
  }
}

resource "aws_kms_key" "kms" {
  description             = "KMS key para Flow Logs"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name = "AUY1105-duocapp-kms"
  }
}

resource "aws_cloudwatch_log_group" "flowlogs" {
  name              = "/aws/vpc/AUY1105-duocapp-flowlogs"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.kms.arn
}

resource "aws_iam_role" "flowlogs_role" {

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
}

resource "aws_iam_role_policy" "flowlogs_policy" {

  name = "AUY1105-duocapp-flowlogs-policy"

  role = aws_iam_role.flowlogs_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_flow_log" "flowlog" {

  vpc_id          = aws_vpc.main.id
  traffic_type    = "ALL"
  iam_role_arn    = aws_iam_role.flowlogs_role.arn
  log_destination = aws_cloudwatch_log_group.flowlogs.arn
}

resource "aws_subnet" "subnet" {

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = false
  availability_zone       = "${var.aws_region}a"
}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "rt" {

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta" {

  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "sg" {

  name   = "AUY1105-duocapp-sg"
  vpc_id = aws_vpc.main.id

  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = [var.ssh_allowed_cidr]
  }

  egress {

    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port   = 443
    to_port     = 443
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }
}