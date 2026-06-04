variable "ami_id" {
  description = "AMI de la instancia"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia"
  type        = string
}

variable "subnet_id" {
  description = "ID de la subnet"
  type        = string
}

variable "security_group_id" {
  description = "ID del Security Group"
  type        = string
}