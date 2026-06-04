variable "aws_region" {
  description = "Region AWS"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR de la VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR de la subnet"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "CIDR permitido para SSH"
  type        = string
}