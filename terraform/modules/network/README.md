# Módulo: network

Este módulo define toda la infraestructura de red en AWS necesaria para el despliegue de la aplicación.

## Recursos creados

- **VPC** (`aws_vpc`): Red privada virtual con CIDR configurable y soporte DNS habilitado.
- **Subnet** (`aws_subnet`): Subred pública dentro de la VPC.
- **Internet Gateway** (`aws_internet_gateway`): Permite la comunicación entre la VPC e internet.
- **Route Table** (`aws_route_table`): Tabla de rutas con salida a internet a través del IGW.
- **Security Group** (`aws_security_group`): Permite acceso SSH entrante desde un CIDR restringido y tráfico saliente HTTP/HTTPS.
- **Default Security Group** (`aws_default_security_group`): Administrado por Terraform para evitar configuraciones por defecto inseguras.
- **VPC Flow Logs** (`aws_flow_log`): Registro de todo el tráfico de red hacia CloudWatch Logs.
- **CloudWatch Log Group**: Almacena los Flow Logs con retención de 365 días y cifrado KMS.
- **KMS Key**: Clave de cifrado para los logs con rotación automática habilitada.
- **IAM Role y Policy**: Permisos para que el servicio de Flow Logs pueda escribir en CloudWatch.
