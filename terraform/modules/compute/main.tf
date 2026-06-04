resource "aws_iam_role" "ec2_role" {

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
}

resource "aws_iam_instance_profile" "ec2_profile" {

  name = "AUY1105-duocapp-ec2-profile"

  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "ec2" {

  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id = var.subnet_id

  vpc_security_group_ids = [
    var.security_group_id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  monitoring    = true
  ebs_optimized = true

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