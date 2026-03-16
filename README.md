# OCI Autoscaling Lab with Terraform

Este proyecto implementa un laboratorio completo de **Auto Scaling en Oracle Cloud Infrastructure (OCI)** utilizando **Terraform**. La infraestructura desplegada permite simular un entorno real de escalamiento automático basado en carga, incluyendo red, balanceador, pool de instancias y políticas de autoscaling.

El objetivo principal es proporcionar un entorno reproducible para **pruebas, demostraciones o aprendizaje** sobre cómo implementar arquitecturas escalables en OCI utilizando **Infrastructure as Code (IaC)**.

La solución despliega automáticamente los siguientes componentes:

* Virtual Cloud Network (VCN)
* Subred pública y privada
* Internet Gateway y reglas de ruteo
* Bastion Host para acceso administrativo
* Load Balancer público
* Instance Configuration
* Instance Pool
* Políticas de Auto Scaling
* Network Security Groups
* Flow Logs
* Etiquetado de recursos

Toda la infraestructura se gestiona mediante **Terraform**, permitiendo crear, modificar o destruir el laboratorio de forma controlada y repetible.

---

# Arquitectura

El laboratorio implementa una arquitectura típica de aplicaciones escalables en OCI:

```
Internet
   │
   │
Public Load Balancer
   │
   │
Instance Pool (Auto Scaling)
   │
   │
Private Subnet
   │
   │
Bastion Host (Public Subnet)
```

Componentes principales:

| Componente             | Descripción                                            |
| ---------------------- | ------------------------------------------------------ |
| VCN                    | Red virtual principal donde se despliegan los recursos |
| Subnet pública         | Utilizada por el Load Balancer y el Bastion            |
| Subnet privada         | Aloja las instancias del Instance Pool                 |
| Bastion                | Permite acceso SSH seguro a recursos internos          |
| Load Balancer          | Distribuye tráfico hacia las instancias                |
| Instance Configuration | Plantilla base para crear instancias                   |
| Instance Pool          | Grupo de instancias gestionadas                        |
| Auto Scaling           | Escala automáticamente las instancias                  |
| NSG                    | Seguridad a nivel de red                               |
| Flow Logs              | Monitoreo del tráfico de red                           |

---

# Estructura del Proyecto

El proyecto sigue una arquitectura modular para mejorar la reutilización y el mantenimiento del código Terraform.

```
.
├── main.tf
├── provider.tf
├── versions.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── modules
│
├── network
│   ├── vcn.tf
│   ├── subnets.tf
│   ├── gateways.tf
│   ├── routes.tf
│   ├── nsg.tf
│   └── flow_logs.tf
│
├── bastion
│   └── bastion.tf
│
├── loadbalancer
│   ├── loadbalancer.tf
│   ├── listener.tf
│   └── backendset.tf
│
├── compute
│   ├── instance_configuration.tf
│   ├── instance_pool.tf
│   └── user_data.yaml
│
└── autoscaling
    └── autoscaling.tf
```

---

# Requisitos

Antes de desplegar el laboratorio se deben cumplir los siguientes requisitos:

| Requisito           | Versión recomendada                     |
| ------------------- | --------------------------------------- |
| Terraform           | >= 1.3                                  |
| OCI CLI             | >= 3.x                                  |
| Cuenta Oracle Cloud | Activa                                  |
| Permisos IAM        | Gestión de red, compute y load balancer |

Además se debe contar con:

* OCID del **compartment**
* Llaves API configuradas en `~/.oci/config`

---

# Configuración del Provider OCI

El provider de OCI utiliza las credenciales configuradas en el archivo estándar de OCI CLI:

```
~/.oci/config
```

Ejemplo:

```
[DEFAULT]
user=ocid1.user.oc1...
fingerprint=xx:xx:xx
tenancy=ocid1.tenancy.oc1...
region=us-ashburn-1
key_file=~/.oci/oci_api_key.pem
```

---

# Variables del Proyecto

Las variables principales se definen en `variables.tf`.

| Variable            | Tipo        | Default         | Descripción                                            |
| ------------------- | ----------- | --------------- | ------------------------------------------------------ |
| compartment_ocid    | string      | —               | OCID del compartment donde se desplegarán los recursos |
| project_name        | string      | autoscaling     | Prefijo utilizado para nombrar los recursos            |
| vcn_cidr            | string      | 10.0.0.0/16     | CIDR principal de la VCN                               |
| public_subnet_cidr  | string      | 10.0.1.0/24     | CIDR de la subred pública                              |
| private_subnet_cidr | string      | 10.0.2.0/24     | CIDR de la subred privada                              |
| tags                | map(string) | environment=dev | Etiquetas aplicadas a los recursos                     |

---

# Archivo terraform.tfvars

El archivo `terraform.tfvars` define los valores específicos del entorno.

Ejemplo:

```
compartment_ocid = "ocid1.compartment.oc1..."
project_name     = "oci-autoscaling-lab"
```

Este archivo permite parametrizar el despliegue sin modificar el código Terraform.

---

# Etiquetado de Recursos (Tags)

El laboratorio incluye soporte para **tags consistentes en todos los recursos**, lo que facilita la administración, auditoría y control de costos.

Ejemplo de estructura:

| Tag         | Valor           | Descripción                 |
| ----------- | --------------- | --------------------------- |
| environment | dev             | Ambiente de despliegue      |
| managed_by  | terraform       | Identifica IaC              |
| project     | autoscaling-lab | Identificación del proyecto |

Los tags pueden ampliarse fácilmente mediante la variable `tags`.

---

# Despliegue del Laboratorio

Inicializar Terraform:

```
terraform init
```

Validar la configuración:

```
terraform validate
```

Visualizar el plan de ejecución:

```
terraform plan
```

Aplicar el despliegue:

```
terraform apply
```

Terraform creará automáticamente todos los recursos definidos en el proyecto.

---

# Auto Scaling

El módulo `autoscaling` configura políticas automáticas para el **Instance Pool**.

El autoscaling permite:

* Incrementar instancias cuando aumenta la carga
* Reducir instancias cuando disminuye la demanda
* Optimizar costos y rendimiento

El escalamiento se basa en métricas de OCI como:

| Métrica         | Uso                              |
| --------------- | -------------------------------- |
| CPU Utilization | Escalar cuando la carga aumenta  |
| Instance Count  | Mantener límites mínimo y máximo |

---

# Instance Pool

El Instance Pool permite administrar un conjunto de instancias idénticas creadas a partir de un **Instance Configuration**.

Beneficios:

* Alta disponibilidad
* Escalabilidad automática
* Actualizaciones controladas
* Integración con Load Balancer

---

# Load Balancer

El módulo `loadbalancer` despliega un **Load Balancer público** que distribuye el tráfico entrante hacia las instancias del pool.

Configuración principal:

| Componente   | Función                               |
| ------------ | ------------------------------------- |
| Listener     | Recibe tráfico HTTP                   |
| Backend Set  | Define las instancias backend         |
| Health Check | Verifica disponibilidad de instancias |

---

# Seguridad

La seguridad se implementa mediante:

| Recurso      | Función                             |
| ------------ | ----------------------------------- |
| NSG          | Control de tráfico entre recursos   |
| Bastion Host | Acceso seguro a instancias privadas |
| Flow Logs    | Auditoría del tráfico de red        |

---

# Outputs

Los outputs definidos en `outputs.tf` exponen información útil después del despliegue.

Ejemplos típicos:

| Output            | Descripción                            |
| ----------------- | -------------------------------------- |
| load_balancer_ip  | Dirección IP pública del Load Balancer |
| bastion_public_ip | IP pública del bastion                 |
| instance_pool_id  | Identificador del Instance Pool        |

---

# Destrucción del Laboratorio

Para eliminar completamente la infraestructura:

```
terraform destroy
```

Esto eliminará todos los recursos creados por Terraform.

---

# Casos de Uso del Laboratorio

Este laboratorio puede utilizarse para:

* Entrenamiento en **OCI Infrastructure as Code**
* Demostraciones de **Auto Scaling**
* Pruebas de arquitectura escalable
* Workshops de **Terraform + OCI**
* Prácticas de **DevOps Cloud**

---

# Buenas Prácticas Implementadas

Este proyecto sigue buenas prácticas de Terraform y OCI:

* Arquitectura modular
* Variables parametrizadas
* Uso de tags
* Separación de responsabilidades por módulos
* Infraestructura reproducible
* Control de versiones con Git
* Uso de Instance Pool + Autoscaling

---

# Licencia

Este proyecto puede utilizarse con fines educativos, de laboratorio o demostración en entornos Oracle Cloud Infrastructure.
