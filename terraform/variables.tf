variable "aws_region" {
  description = "Region de AWS donde se desplegara la infraestructura"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "Bloque CIDR para la VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "subnet_cidr" {
  description = "Bloque CIDR para la subred publica"
  type        = string
  default     = "10.1.1.0/24"
}

variable "ami_id" {
  description = "AMI de Ubuntu 24.04 LTS para la instancia EC2"
  type        = string
  default     = "ami-0e86e20dae9224db8"
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "ssh_allowed_cidr" {
  description = "CIDR permitido para acceso SSH (no usar 0.0.0.0/0)"
  type        = string
  default     = "10.0.0.0/8"
}
