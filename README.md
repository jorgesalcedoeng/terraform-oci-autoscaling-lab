# Terraform OCI Autoscaling Lab

Laboratorio de **Infraestructura como Código (IaC)** que despliega una arquitectura escalable en **Oracle Cloud Infrastructure (OCI)** usando **Terraform**.

El proyecto crea una infraestructura completa que incluye red, instancias de cómputo, balanceador de carga y políticas de **autoscaling**.

---

# Arquitectura

Componentes desplegados:

- Virtual Cloud Network (VCN)
- Subnet pública y privada
- Bastion Host
- Instance Pool
- Load Balancer
- Autoscaling
- Network Security Groups
- Flow Logs

---

# Estructura del Proyecto

```

.
├── main.tf
├── provider.tf
├── versions.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── modules
│   ├── network
│   ├── compute
│   ├── loadbalancer
│   ├── autoscaling
│   └── bastion

```

---

# Módulos Terraform

| Módulo | Descripción |
|---|---|
| network | Crea VCN, subnets, gateways, NSG y rutas |
| compute | Instance configuration e instance pool |
| loadbalancer | OCI Load Balancer |
| autoscaling | Políticas de autoscaling |
| bastion | Bastion host para acceso SSH |

---

# Variables

|Name|Description|Type|Default|Required|
|---|---|---|---|---|
|compartment_ocid||string||yes|
|project_name|Prefix used for naming resources|string|"autoscaling"|no|
|vcn_cidr||string|"10.0.0.0/16"|no|
|public_subnet_cidr||string|"10.0.1.0/24"|no|
|private_subnet_cidr||string|"10.0.2.0/24"|no|
|tags||map(string)|{|no|


---

# Outputs

|Name|Description|
|---|---|
|vcn_id||
|public_subnet_id||
|private_subnet_id||
|loadbalancer_ip||


---

# Despliegue

Inicializar Terraform

```
terraform init
```

Plan

```
terraform plan
```

Aplicar infraestructura

```
terraform apply
```

---

# Prueba de Autoscaling

Una vez desplegado el entorno, se puede generar carga en las instancias:

```
stress --cpu 2 --timeout 300
```

Esto provocará que la política de autoscaling aumente el número de instancias del pool.

---

# Destruir Infraestructura

```
terraform destroy
```

---

# Autor

Jorge Salcedo  
Cloud / DevOps Engineer