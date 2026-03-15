
# 🚀 OCI Autoscaling Infrastructure con Terraform

![Terraform](https://img.shields.io/badge/Terraform-1.5%2B-623CE4?logo=terraform&logoColor=white)
![OCI](https://img.shields.io/badge/Oracle%20Cloud-Infrastructure-F80000?logo=oracle&logoColor=white)
![DevOps](https://img.shields.io/badge/DevOps-Automation-orange)
![License](https://img.shields.io/badge/License-MIT-green)

---

# 📘 Descripción

Este proyecto implementa **Infraestructura como Código (IaC)** utilizando **Terraform** para desplegar una arquitectura escalable en **Oracle Cloud Infrastructure (OCI)**.

La solución crea automáticamente:

- Virtual Cloud Network (VCN)
- Subred pública y privada
- Bastion Host
- Load Balancer
- Instance Configuration
- Instance Pool
- Autoscaling
- Network Security Groups (NSG)
- Flow Logs

El objetivo del proyecto es demostrar cómo implementar **infraestructura escalable y segura en OCI** siguiendo buenas prácticas de **Cloud Architecture y DevOps**.

---

# 🏗 Arquitectura

```
                    Internet
                       │
                       ▼
               ┌─────────────────┐
               │ OCI LoadBalancer│
               │   (Public)      │
               └────────┬────────┘
                        │
                ┌───────▼────────┐
                │ Instance Pool  │
                │ AutoScaling    │
                │ Private Subnet │
                └───────┬────────┘
                        │
                ┌───────▼────────┐
                │   Private VCN  │
                │ Security Rules │
                └────────────────┘

        ┌─────────────────────────────┐
        │ Bastion Host (Public Subnet)│
        │ Acceso SSH seguro           │
        └─────────────────────────────┘
```

---

# 📂 Estructura del Repositorio

```
terraform-oci-autoscaling
│
├── main.tf
├── provider.tf
├── versions.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
│
├── modules
│   ├── network
│   ├── compute
│   ├── loadbalancer
│   ├── autoscaling
│   └── bastion
│
└── README.md
```

---

# 📦 Módulos

| Módulo | Descripción |
|------|-------------|
| network | Crea VCN, subnets, gateways, route tables y NSG |
| compute | Crea instance configuration y instance pool |
| loadbalancer | Implementa OCI Load Balancer |
| autoscaling | Define políticas de autoscaling |
| bastion | Bastion host para acceso seguro |

---

# ⚙️ Requisitos

| Herramienta | Versión |
|-------------|--------|
| Terraform | >= 1.5 |
| OCI Provider | >= 5.x |
| OCI CLI | Opcional |

---

# 🔧 Configuración del Provider

Terraform utiliza la configuración del **OCI CLI**.

Archivo:

```
~/.oci/config
```

Ejemplo:

```
[DEFAULT]
user=ocid1.user.oc1...
fingerprint=xx:xx:xx
key_file=~/.oci/oci_api_key.pem
tenancy=ocid1.tenancy.oc1...
region=us-ashburn-1
```

Provider:

```hcl
provider "oci" {
  config_file_profile = "DEFAULT"
}
```

---

# 📥 Variables de Entrada

| Nombre | Descripción | Tipo | Default | Requerido |
|------|-------------|------|--------|-----------|
| compartment_ocid | OCID del compartment de OCI | string | n/a | Sí |
| project_name | Prefijo usado para nombrar recursos | string | autoscaling | No |
| vcn_cidr | CIDR de la VCN | string | 10.0.0.0/16 | No |
| public_subnet_cidr | CIDR de la subred pública | string | 10.0.1.0/24 | No |
| private_subnet_cidr | CIDR de la subred privada | string | 10.0.2.0/24 | No |
| instance_shape | Shape de las instancias | string | VM.Standard.E4.Flex | No |
| instance_count | Número inicial de instancias | number | 2 | No |
| tags | Freeform tags para los recursos | map(string) | {{}} | No |

Ejemplo:

```hcl
compartment_ocid = "ocid1.compartment.oc1..."
project_name     = "oci-autoscaling-lab"
```

---

# 📤 Outputs

| Output | Descripción |
|------|-------------|
| vcn_id | ID de la VCN creada |
| public_subnet_id | ID de la subred pública |
| private_subnet_id | ID de la subred privada |
| loadbalancer_ip | IP pública del Load Balancer |
| instance_pool_id | ID del Instance Pool |

---

# 🚀 Despliegue

## 1 Clonar repositorio

```bash
git clone https://github.com/tu-org/terraform-oci-autoscaling.git
cd terraform-oci-autoscaling
```

## 2 Inicializar Terraform

```bash
terraform init
```

## 3 Validar configuración

```bash
terraform validate
```

## 4 Ver plan

```bash
terraform plan
```

## 5 Aplicar infraestructura

```bash
terraform apply
```

---

# 📈 Autoscaling

La infraestructura utiliza **OCI Instance Pools con Autoscaling**.

| Métrica | Acción |
|------|------|
| CPU > 70% | Escalar (Scale Out) |
| CPU < 30% | Reducir (Scale In) |

Beneficios:

- Alta disponibilidad
- Escalabilidad automática
- Optimización de costos

---

# 🔒 Seguridad

Buenas prácticas implementadas:

- Subred privada para instancias
- Acceso público solo a través del Load Balancer
- Bastion host para acceso SSH
- Network Security Groups
- Flow Logs habilitados

---

# 🧠 Buenas prácticas DevOps

- Infraestructura como Código
- Arquitectura modular con Terraform
- Reutilización de módulos
- Parametrización de variables
- Estrategia de autoscaling

