output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "ID de la subred creada"
  value       = aws_subnet.subnet.id
}

output "security_group_id" {
  description = "ID del Security Group"
  value       = aws_security_group.sg.id
}