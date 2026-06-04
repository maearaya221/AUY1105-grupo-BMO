output "vpc_id" {
  description = "ID de la VPC"
  value       = module.network.vpc_id
}

output "subnet_id" {
  description = "ID de la subnet"
  value       = module.network.subnet_id
}

output "security_group_id" {
  description = "ID del Security Group"
  value       = module.network.security_group_id
}

output "ec2_instance_id" {
  description = "ID de la instancia EC2"
  value       = module.compute.instance_id
}

output "ec2_public_ip" {
  description = "IP publica EC2"
  value       = module.compute.instance_ip
}
