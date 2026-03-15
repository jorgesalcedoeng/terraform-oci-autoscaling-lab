# 🚀 OCI Load Balancer Lab with Terraform

![Terraform](https://img.shields.io/badge/Terraform-IaC-623CE4?logo=terraform)
![OCI](https://img.shields.io/badge/Oracle%20Cloud-OCI-red?logo=oracle)
![License](https://img.shields.io/badge/license-MIT-green)
![Status](https://img.shields.io/badge/lab-learning-blue)

Laboratorio práctico para desplegar una **arquitectura con Load Balancer
en Oracle Cloud Infrastructure (OCI)** utilizando **Terraform y una
estructura modular**.

El proyecto demuestra cómo implementar **Infraestructura como Código
(IaC)** para crear un **Load Balancer público que distribuye tráfico
HTTP entre múltiples instancias compute** desplegadas en una subred
privada.

Este laboratorio está pensado para **aprendizaje, demostraciones
técnicas y compartir conocimiento sobre OCI + Terraform**.

------------------------------------------------------------------------

# 📐 Arquitectura

El laboratorio implementa una arquitectura simple donde un **OCI Load
Balancer público** distribuye tráfico entre **dos servidores Nginx**.

                             Internet
                                 │
                                 ▼
                       OCI Public Load Balancer
                           (HTTP Listener)
                                 │
                      ┌──────────┴──────────┐
                      ▼                     ▼
               Compute Instance 1     Compute Instance 2
                     (Nginx)                (Nginx)
                      │                     │
                      └────── Private Subnet ──────┘
                                │
                               VCN

------------------------------------------------------------------------

# 🧱 Recursos desplegados

## Networking

-   Virtual Cloud Network (**VCN**)
-   Public Subnet
-   Private Subnet
-   Internet Gateway
-   Route Tables
-   Network Security Groups

## Compute

-   2 instancias **OCI Compute**
-   Instalación automática de **Nginx** mediante `cloud-init`
-   Página web generada automáticamente para identificar el backend

## Load Balancing

-   **OCI Public Load Balancer**
-   Backend Set
-   Listener HTTP (puerto 80)
-   Health Checks HTTP
-   Política de balanceo **Round Robin**

------------------------------------------------------------------------

# 📂 Estructura del Proyecto

El proyecto sigue una **estructura modular de Terraform**, separando la infraestructura de red y la capa de cómputo en módulos reutilizables.

```
terraform-oci-loadbalancer-lab/
│
├── main.tf
├── provider.tf
├── versions.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── README.md
│
├── oci-lab
├── oci-lab.pub
│
└── modules
    │
    ├── network
    │   ├── vcn.tf
    │   ├── subnets.tf
    │   ├── gateways.tf
    │   ├── routes.tf
    │   ├── nsg.tf
    │   ├── sl.tf
    │   ├── flow_logs.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── compute
        ├── vm.tf
        ├── loadbalancer.tf
        ├── data.tf
        ├── variables.tf
        ├── outputs.tf
        └── user_data.yaml
```

## Descripción de los componentes

| Componente | Descripción |
|------------|-------------|
| `main.tf` | Punto de entrada del proyecto Terraform donde se llaman los módulos |
| `provider.tf` | Configuración del provider de Oracle Cloud Infrastructure |
| `versions.tf` | Definición de versiones de Terraform y providers |
| `variables.tf` | Declaración de variables globales |
| `terraform.tfvars` | Valores de variables utilizados en el despliegue |
| `outputs.tf` | Outputs del despliegue principal |
| `oci-lab / oci-lab.pub` | Claves SSH utilizadas para acceder a las instancias |
| `modules/network` | Módulo que crea la infraestructura de red (VCN, subnets, gateways, NSG) |
| `modules/compute` | Módulo encargado de desplegar las instancias compute y el Load Balancer |
| `user_data.yaml` | Script de `cloud-init` que instala y configura Nginx automáticamente |

------------------------------------------------------------------------

# ⚙️ Variables principales

Las siguientes variables permiten parametrizar el laboratorio para adaptarlo a distintos entornos dentro de OCI.

| Variable | Descripción | Ejemplo |
|--------|-------------|--------|
| `compartment_ocid` | OCID del compartment donde se desplegarán los recursos | `ocid1.compartment...` |
| `vcn_cidr` | Rango CIDR de la Virtual Cloud Network | `10.0.0.0/16` |
| `public_subnet_cidr` | CIDR de la subred pública donde se despliega el Load Balancer | `10.0.1.0/24` |
| `private_subnet_cidr` | CIDR de la subred privada donde se despliegan las instancias | `10.0.2.0/24` |
| `instance_shape` | Shape de las instancias compute | `VM.Standard.E2.1.Micro` |
| `instance_image` | Imagen del sistema operativo utilizada para las VMs | `Oracle Linux` |

Estas variables pueden definirse en un archivo `terraform.tfvars` o mediante variables de entorno.

------------------------------------------------------------------------

# ⚖️ Load Balancer

El laboratorio implementa un **OCI Public Load Balancer** que distribuye tráfico HTTP hacia dos instancias compute que ejecutan Nginx.

El balanceador se despliega en la **subred pública**, mientras que las instancias backend se encuentran en la **subred privada**, lo cual es una práctica común para mejorar la seguridad de la arquitectura.

## Configuración principal

| Configuración | Valor |
|---------------|------|
| Tipo | Public Load Balancer |
| Shape | Flexible |
| Bandwidth | 10 – 100 Mbps |
| Listener | HTTP |
| Puerto | 80 |
| Política de balanceo | Round Robin |

## Backend Set

El backend set registra las instancias compute como servidores backend que recibirán tráfico del balanceador.

| Backend | Puerto |
|--------|------|
| VM1 | 80 |
| VM2 | 80 |

## Health Check

El Load Balancer utiliza un **Health Check HTTP** para verificar que los servidores backend estén disponibles.

Protocol: HTTP
Port: 80
Path: /
Interval: 10s
Timeout: 3s
Retries: 3

Si una instancia no responde correctamente al health check, el Load Balancer dejará de enviar tráfico a esa VM hasta que vuelva a estar disponible.

------------------------------------------------------------------------

# 🔁 Flujo de tráfico

1.  El usuario accede a la **IP pública del Load Balancer**
2.  El **listener HTTP** recibe la conexión
3.  El **backend set** aplica la política **Round Robin**
4.  El tráfico se distribuye entre las dos VMs

Al refrescar la página se observará que **el backend cambia**, lo que
confirma que el balanceo funciona correctamente.

------------------------------------------------------------------------

# ▶️ Despliegue

### 1 Inicializar Terraform

``` bash
terraform init
```

### 2 Validar configuración

``` bash
terraform validate
```

### 3 Plan de ejecución

``` bash
terraform plan
```

### 4 Crear infraestructura

``` bash
terraform apply
```

------------------------------------------------------------------------

# 🧪 Prueba del laboratorio

Una vez que la infraestructura ha sido desplegada correctamente, se puede validar el funcionamiento del balanceador.

## Paso 1 — Obtener la IP pública del Load Balancer
http://LOAD_BALANCER_IP

------------------------------------------------------------------------

# ⚠️ Troubleshooting

## Health Check "Inaccessible"

En algunos casos el **Health Check del Load Balancer puede aparecer como
`Inaccessible` o `Unhealthy`** después del despliegue.

Esto puede ocurrir porque:

-   `cloud-init` aún está ejecutándose
-   Nginx no terminó de instalarse
-   El servicio web aún no está activo

### Recomendación

Reiniciar las instancias compute.

Desde la consola OCI o CLI:

    Reboot VM1
    Reboot VM2

Después de reiniciar:

1.  Esperar algunos minutos
2.  Verificar nuevamente el estado del health check

Normalmente cambiará a **Healthy** cuando **Nginx responda en el puerto
80**.

------------------------------------------------------------------------

# 🎯 Objetivos del laboratorio

Este laboratorio permite aprender:

-   Infraestructura como código con **Terraform**
-   Arquitecturas modulares en Terraform
-   Configuración de **OCI Load Balancer**
-   Backend Sets y Health Checks
-   Automatización de servidores con **cloud-init**

------------------------------------------------------------------------

# 🧑‍💻 Tecnologías

-   Terraform
-   Oracle Cloud Infrastructure (OCI)
-   OCI Load Balancer
-   Nginx
-   Cloud-init

------------------------------------------------------------------------

# 📚 Posibles mejoras

Algunas extensiones posibles del laboratorio:

-   Implementar **HTTPS**
-   Agregar **OCI WAF**
-   Implementar **Auto Scaling**
-   Crear un **Bastion Host**
-   Integrar **Monitoring / Logging**
-   Implementar **Private Load Balancer**

------------------------------------------------------------------------

# 📖 Propósito

Este laboratorio fue creado con fines **educativos y de demostración
técnica**, para mostrar cómo desplegar una arquitectura simple de
**balanceo de carga en OCI usando Terraform** siguiendo buenas prácticas
de infraestructura como código.
