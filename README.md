# Terraform OCI Autoscaling Lab

![Terraform](https://img.shields.io/badge/Terraform-IaC-623CE4?logo=terraform)
![Oracle
Cloud](https://img.shields.io/badge/Oracle%20Cloud-OCI-red?logo=oracle)
![Infraestructura como
Código](https://img.shields.io/badge/Infraestructura-IaC-blue)
![DevOps](https://img.shields.io/badge/DevOps-Automation-green)

Laboratorio práctico para desplegar **infraestructura con Autoescalado
en Oracle Cloud Infrastructure (OCI)** utilizando **Terraform**.

Este proyecto demuestra cómo implementar **Infraestructura como Código
(IaC)** para desplegar una arquitectura escalable capaz de ajustar
automáticamente la capacidad de cómputo dependiendo de la carga de
trabajo.

El laboratorio está orientado a **ingenieros Cloud, DevOps y
estudiantes** que desean aprender a automatizar infraestructura en OCI
usando Terraform.

------------------------------------------------------------------------

# Arquitectura

Este laboratorio despliega una arquitectura escalable en OCI compuesta
por:

-   Virtual Cloud Network (VCN)
-   Subred pública
-   Internet Gateway
-   Instancias de cómputo
-   Instance Configuration
-   Instance Pool
-   Políticas de Autoescalado
-   Load Balancer

El **autoescalado** permite aumentar o reducir el número de instancias
automáticamente según métricas definidas como el **uso de CPU**.

## Arquitectura de Alto Nivel

                     Internet
                         │
                  ┌───────────────┐
                  │  Load Balancer │
                  └───────┬───────┘
                          │
                  ┌───────────────┐
                  │ Instance Pool │
                  │  AutoScaling  │
                  └───────┬───────┘
                          │
            ┌─────────────┼─────────────┐
            │             │             │
       Compute VM     Compute VM     Compute VM
           Nodo           Nodo           Nodo
            │              │              │
            └────────── Virtual Cloud Network ──────────┘

------------------------------------------------------------------------

# Estructura del Proyecto

    terraform-oci-autoscaling-lab/
    │
    ├── provider.tf
    ├── variables.tf
    ├── terraform.tfvars
    ├── network.tf
    ├── compute.tf
    ├── autoscaling.tf
    ├── outputs.tf
    └── README.md

  Archivo            Descripción
  ------------------ ---------------------------------------------
  provider.tf        Configuración del proveedor OCI
  variables.tf       Definición de variables de Terraform
  terraform.tfvars   Valores de variables
  network.tf         Recursos de red (VCN, subred, gateways)
  compute.tf         Configuración de instancias y instance pool
  autoscaling.tf     Configuración de autoescalado
  outputs.tf         Salidas generadas por Terraform

------------------------------------------------------------------------

# Prerrequisitos

Antes de ejecutar este laboratorio necesitas:

-   Una cuenta en **Oracle Cloud Infrastructure**
-   **Terraform \>= 1.0**
-   **OCI CLI configurado**
-   Permisos adecuados en OCI

## Permisos requeridos

El usuario debe tener permisos para administrar:

-   Virtual Cloud Networks
-   Instancias de cómputo
-   Instance Pools
-   Load Balancers
-   Configuraciones de Autoescalado

------------------------------------------------------------------------

# Instalación de Terraform

Descargar Terraform:

https://developer.hashicorp.com/terraform/downloads

Verificar instalación:

``` bash
terraform -version
```

------------------------------------------------------------------------

# Autenticación en OCI

Terraform utiliza las credenciales configuradas en:

    ~/.oci/config

Ejemplo:

    [DEFAULT]
    user=ocid1.user.oc1..xxxxx
    fingerprint=xx:xx:xx
    tenancy=ocid1.tenancy.oc1..xxxxx
    region=us-ashburn-1
    key_file=~/.oci/oci_api_key.pem

------------------------------------------------------------------------

# Configuración

Editar el archivo **terraform.tfvars** con los valores de tu entorno.

Ejemplo:

``` hcl
tenancy_ocid     = "ocid1.tenancy.oc1..xxxxx"
user_ocid        = "ocid1.user.oc1..xxxxx"
compartment_ocid = "ocid1.compartment.oc1..xxxxx"

region           = "us-ashburn-1"

instance_shape   = "VM.Standard.E4.Flex"
instance_count   = 2
```

------------------------------------------------------------------------

# Variables de Terraform

  ----------------------------------------------------------------------------------------
  Nombre             Descripción          Tipo      Default               Requerido
  ------------------ -------------------- --------- --------------------- ----------------
  tenancy_ocid       OCID del tenancy     string    n/a                   sí

  user_ocid          OCID del usuario     string    n/a                   sí

  compartment_ocid   OCID del             string    n/a                   sí
                     compartimento                                        

  region             Región OCI           string    us-ashburn-1          no

  instance_shape     Shape de instancia   string    VM.Standard.E4.Flex   no

  instance_count     Número inicial de    number    2                     no
                     instancias                                           
  ----------------------------------------------------------------------------------------

------------------------------------------------------------------------

# Flujo de Trabajo Terraform

    terraform init
    terraform validate
    terraform plan
    terraform apply

------------------------------------------------------------------------

# Despliegue

Inicializar Terraform:

``` bash
terraform init
```

Validar configuración:

``` bash
terraform validate
```

Planificar cambios:

``` bash
terraform plan
```

Aplicar infraestructura:

``` bash
terraform apply
```

------------------------------------------------------------------------

# Pruebas de Autoescalado

Para probar el autoscaling se puede generar carga en las instancias.

Ejemplo:

``` bash
sudo yum install stress
stress --cpu 2 --timeout 300
```

Cuando el CPU supere el umbral configurado:

-   OCI aumentará automáticamente el número de instancias.

Cuando la carga disminuya:

-   OCI reducirá automáticamente el número de instancias.

------------------------------------------------------------------------

# Outputs de Terraform

  Output                    Descripción
  ------------------------- ------------------------------
  load_balancer_public_ip   IP pública del Load Balancer
  instance_pool_id          OCID del Instance Pool
  vcn_id                    OCID de la red VCN

Ejemplo:

    load_balancer_public_ip = xxx.xxx.xxx.xxx
    instance_pool_id        = ocid1.instancepool.oc1..
    vcn_id                  = ocid1.vcn.oc1..

------------------------------------------------------------------------

# Eliminar Infraestructura

Para eliminar todos los recursos creados:

``` bash
terraform destroy
```

------------------------------------------------------------------------

# Objetivos de Aprendizaje

Este laboratorio permite comprender:

-   Infraestructura como Código con Terraform
-   Redes en Oracle Cloud Infrastructure
-   Instance Pools
-   Autoscaling en OCI
-   Arquitecturas escalables en la nube

------------------------------------------------------------------------

# Referencias

Terraform Documentation\
https://developer.hashicorp.com/terraform/docs

OCI Terraform Provider\
https://registry.terraform.io/providers/oracle/oci/latest/docs

OCI Autoscaling\
https://docs.oracle.com/en-us/iaas/Content/Compute/Tasks/autoscalinginstancepools.htm

------------------------------------------------------------------------

# Autor

**Jorge Salcedo**

Cloud / DevOps Engineer\
https://github.com/jorgesalcedoeng
