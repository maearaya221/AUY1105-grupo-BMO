Changelog
Todos los cambios notables de este proyecto serán documentados en este archivo.

[1.0.0] - 2026-04-28
Añadido (Added)
Repositorio (PR #1): Configuración inicial del repositorio. Creación de los archivos base README.md, .gitignore (excluyendo secretos y archivos de estado de Terraform) y CHANGELOG.md.
Infraestructura (PR #2): Creación del código Terraform (main.tf y provider.tf) usando el proveedor AWS v5.x. Se implementó:
VPC con CIDR 10.1.0.0/16.
Dos subredes públicas con máscara /24.
Internet Gateway y Tablas de Enrutamiento asociadas.
Grupo de Seguridad (Security Group) para permitir tráfico SSH.
Instancia EC2 tipo t2.micro con imagen AMI dinámica de Ubuntu 24.04 LTS.
Automatización (PR #3): Implementación de flujo CI/CD con GitHub Actions (.github/workflows/terraform-ci.yml). El pipeline consta de tres etapas secuenciales:
Análisis estático con TFLint.
Análisis de seguridad con Checkov.
Validación de sintaxis con Terraform Validate.
Políticas OPA (PR #4): Creación del directorio policies/ con el archivo terraform.rego. Se definieron dos reglas estrictas de cumplimiento:
Denegar la creación de instancias que no sean del tipo t2.micro.
Denegar la apertura del puerto 22 (SSH) hacia todo internet (0.0.0.0/0).

Corregido / Seguridad (Security)
Cierre de vulnerabilidad (PR #5): Se actualizó el Security Group en main.tf para remover el acceso SSH público (0.0.0.0/0) que fue detectado por los análisis de seguridad, restringiéndolo a una IP específica (190.0.0.1/32) para cumplir con las políticas de OPA.