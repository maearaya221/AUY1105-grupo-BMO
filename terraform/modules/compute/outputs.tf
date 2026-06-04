output "instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.ec2.id
}

output "instance_ip" {
  description = "IP publica de la instancia EC2"
  value       = aws_instance.ec2.public_ip
}
