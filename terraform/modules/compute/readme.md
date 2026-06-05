# Módulo: compute

Este módulo define los recursos de cómputo en AWS necesarios para ejecutar la instancia de la aplicación.

## Recursos creados

- **EC2 Instance** (`aws_instance`): Instancia virtual Ubuntu 24.04 LTS tipo `t2.micro` con las siguientes configuraciones de seguridad:
  - IMDSv2 obligatorio (protección contra ataques SSRF).
  - Volumen raíz EBS cifrado.
  - Monitoreo detallado habilitado.
  - Optimización EBS activada.
- **IAM Role** (`aws_iam_role`): Rol con permisos mínimos asignado a la instancia EC2.
- **IAM Instance Profile** (`aws_iam_instance_profile`): Perfil que vincula el IAM Role a la instancia EC2.
