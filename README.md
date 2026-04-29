# AUY1105-grupo-N
## Infraestructura como Código II — Evaluación Parcial N°1

## Propósito General

Este repositorio contiene el código de infraestructura como código (IaC) desarrollado con **Terraform** para desplegar una infraestructura básica en AWS, junto con un pipeline de automatización mediante **GitHub Actions** que analiza la calidad y seguridad del código.

---

## Objetivos del Repositorio

- Definir infraestructura en AWS usando Terraform (VPC, Subnets, Security Groups, EC2).
- Automatizar el análisis de calidad con TFLint.
- Automatizar el análisis de seguridad con Checkov.
- Validar el código Terraform con terraform validate.
- Implementar políticas de seguridad con Open Policy Agent.
- Aplicar buenas prácticas de revisión de código mediante Pull Requests.

---

## Estructura del Repositorio

```
AUY1105-grupo-N/
├── .github/
│   └── workflows/
│       └── terraform-ci.yml       # Workflow GitHub Actions
├── terraform/
│   ├── main.tf                    # Recursos principales (VPC, EC2, etc.)
│   ├── variables.tf               # Variables del proyecto
│   ├── outputs.tf                 # Outputs de Terraform
│   └── provider.tf                # Configuración del proveedor AWS
├── policies/
│   ├── no_public_ssh.rego         # Política OPA: bloquear SSH público
│   └── only_t2_micro.rego         # Política OPA: solo instancias t2.micro
├── .gitignore
├── CHANGELOG.md
└── README.md
```

---

## Definición del Código Terraform

El código Terraform define los siguientes recursos en AWS:

| Recurso | Nombre | Descripción |
|---|---|---|
| VPC | AUY1105-duocapp-vpc | Red principal con CIDR 10.1.0.0/16 |
| Subnet pública | AUY1105-duocapp-subnet | Subred con máscara /24 |
| Security Group | AUY1105-duocapp-sg | Permite SSH entrante, todo el tráfico saliente |
| EC2 Instance | AUY1105-duocapp-ec2 | Ubuntu 24.04 LTS, tipo t2.micro |

### Proveedor
- Cloud: Amazon Web Services (AWS)
- Versión del proveedor: ~> 6.0 (última versión)

---

## Instrucciones Básicas de Uso

### Pre-requisitos
- Tener instalado Terraform
- Tener configuradas las credenciales de AWS (aws configure)
- Tener instalado TFLint
- Tener instalado Checkov

### Pasos para desplegar

```bash
# 1. Clonar el repositorio
git clone https://github.com/<tu-usuario>/AUY1105-grupo-N.git
cd AUY1105-grupo-N

# 2. Inicializar Terraform
cd terraform
terraform init

# 3. Validar el código
terraform validate

# 4. Ver los cambios planificados
terraform plan

# 5. Aplicar la infraestructura
terraform apply
```

### Ejecutar análisis manualmente

```bash
# Análisis estático con TFLint
tflint --chdir=terraform/

# Análisis de seguridad con Checkov
checkov -d terraform/
```

---

## Pipeline CI/CD (GitHub Actions)

El workflow se activa automáticamente en cada Pull Request hacia main y ejecuta:

1. Análisis estático → TFLint
2. Análisis de seguridad → Checkov
3. Validación → terraform validate

---

## Integrante

| Nombre | Usuario GitHub |
|---|---|
| Integrante | Oscar Neira |
| Integrante | Brandon Figueroa |
| Integrante | Matias Araya |
