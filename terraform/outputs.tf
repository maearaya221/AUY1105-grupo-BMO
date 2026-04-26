output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.AUY1105-duocapp-vpc.id
}

output "subnet_id" {
  description = "ID de la subred publica creada"
  value       = aws_subnet.AUY1105-duocapp-subnet.id
}

output "security_group_id" {
  description = "ID del Security Group creado"
  value       = aws_security_group.AUY1105-duocapp-sg.id
}

output "ec2_instance_id" {
  description = "ID de la instancia EC2 creada"
  value       = aws_instance.AUY1105-duocapp-ec2.id
}

output "ec2_public_ip" {
  description = "IP publica de la instancia EC2"
  value       = aws_instance.AUY1105-duocapp-ec2.public_ip
}
