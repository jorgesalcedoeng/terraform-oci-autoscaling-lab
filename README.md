# OCI Autoscaling Infrastructure with Terraform

![Terraform](https://img.shields.io/badge/Terraform-1.5%2B-623CE4?logo=terraform&logoColor=white)
![Oracle
Cloud](https://img.shields.io/badge/Oracle%20Cloud-OCI-F80000?logo=oracle&logoColor=white)
![IaC](https://img.shields.io/badge/Infrastructure-as-Code-blue)
![DevOps](https://img.shields.io/badge/DevOps-Automation-orange)
![License](https://img.shields.io/badge/License-MIT-green)

------------------------------------------------------------------------

# Overview

This project provides a **modular Terraform implementation for deploying
an autoscaling architecture in Oracle Cloud Infrastructure (OCI)**.

The infrastructure provisions a **production-style cloud architecture**
including:

-   Virtual Cloud Network (VCN)
-   Public and Private Subnets
-   Internet Gateway and NAT Gateway
-   Bastion Host
-   OCI Load Balancer
-   Compute Instance Configuration
-   Instance Pool
-   Autoscaling Policies
-   Network Security Groups (NSG)
-   Flow Logs

The solution follows **Infrastructure as Code (IaC), DevOps and Cloud
Architecture best practices**.

------------------------------------------------------------------------

# Architecture

                        Internet
                           │
                           ▼
                   ┌─────────────────┐
                   │ OCI LoadBalancer│
                   │     Public      │
                   └────────┬────────┘
                            │
                     ┌──────▼──────┐
                     │ InstancePool│
                     │ AutoScaling │
                     │ Private Sub │
                     └──────┬──────┘
                            │
                   ┌────────▼────────┐
                   │ Private Network │
                   │ NSG + Routing   │
                   └─────────────────┘

            ┌─────────────────────────────┐
            │ Bastion Host (Public Subnet)│
            │ Secure SSH Access           │
            └─────────────────────────────┘

------------------------------------------------------------------------

# Repository Structure

    oci-autoscaling/
    │
    ├── main.tf
    ├── provider.tf
    ├── versions.tf
    ├── variables.tf
    ├── outputs.tf
    ├── terraform.tfvars
    │
    ├── modules/
    │   ├── network/
    │   ├── compute/
    │   ├── loadbalancer/
    │   ├── autoscaling/
    │   └── bastion/
    │
    └── README.md

------------------------------------------------------------------------

# Modules

  -----------------------------------------------------------------------
  Module                 Description
  ---------------------- ------------------------------------------------
  **network**            Creates VCN, subnets, gateways, routing tables
                         and NSGs

  **compute**            Creates instance configuration and instance
                         pools

  **loadbalancer**       Deploys OCI Load Balancer, backend sets and
                         listeners

  **autoscaling**        Defines autoscaling policies

  **bastion**            Bastion host used to access private instances
                         securely
  -----------------------------------------------------------------------

------------------------------------------------------------------------

# Requirements

  Tool           Version
  -------------- -------------
  Terraform      \>= 1.5
  OCI Provider   \>= 5.x
  OCI CLI        Recommended

------------------------------------------------------------------------

# Provider Configuration

Terraform authenticates using the **OCI CLI configuration file**.

Example:

    ~/.oci/config

    [DEFAULT]
    user=ocid1.user.oc1...
    fingerprint=xx:xx:xx
    key_file=~/.oci/oci_api_key.pem
    tenancy=ocid1.tenancy.oc1...
    region=us-ashburn-1

Provider block:

``` hcl
provider "oci" {
  config_file_profile = "DEFAULT"
}
```

------------------------------------------------------------------------

# Input Variables

  ------------------------------------------------------------------------------------------------
  Name                  Description             Type          Default               Required
  --------------------- ----------------------- ------------- --------------------- --------------
  compartment_ocid      OCI compartment OCID    string        n/a                   yes
                        where resources will be                                     
                        deployed                                                    

  project_name          Prefix used to name     string        autoscaling           no
                        resources                                                   

  vcn_cidr              CIDR block for the VCN  string        10.0.0.0/16           no

  public_subnet_cidr    CIDR block for public   string        10.0.1.0/24           no
                        subnet                                                      

  private_subnet_cidr   CIDR block for private  string        10.0.2.0/24           no
                        subnet                                                      

  instance_shape        Shape of compute        string        VM.Standard.E4.Flex   no
                        instances                                                   

  instance_count        Initial number of       number        2                     no
                        instances                                                   

  tags                  Freeform tags applied   map(string)   {}                    no
                        to resources                                                
  ------------------------------------------------------------------------------------------------

Example:

``` hcl
compartment_ocid = "ocid1.compartment.oc1..."
project_name     = "oci-autoscaling-lab"
```

------------------------------------------------------------------------

# Outputs

  Name                Description
  ------------------- ----------------------------------------
  vcn_id              ID of the created VCN
  public_subnet_id    ID of the public subnet
  private_subnet_id   ID of the private subnet
  loadbalancer_ip     Public IP address of the Load Balancer
  instance_pool_id    ID of the Instance Pool

------------------------------------------------------------------------

# Deployment

## 1 Clone repository

``` bash
git clone https://github.com/your-org/oci-autoscaling.git
cd oci-autoscaling
```

## 2 Initialize Terraform

``` bash
terraform init
```

## 3 Validate configuration

``` bash
terraform validate
```

## 4 Review execution plan

``` bash
terraform plan
```

## 5 Deploy infrastructure

``` bash
terraform apply
```

------------------------------------------------------------------------

# Autoscaling Strategy

Autoscaling is implemented using **OCI Instance Pools**.

  Metric                   Action
  ------------------------ -----------
  CPU Utilization \> 70%   Scale Out
  CPU Utilization \< 30%   Scale In

Benefits:

-   High availability
-   Elastic infrastructure
-   Cost optimization

------------------------------------------------------------------------

# Security Best Practices

This infrastructure implements several security measures:

-   Private subnet for compute instances
-   Public access only through the load balancer
-   Bastion host for controlled SSH access
-   Network Security Groups
-   Flow logs for traffic monitoring

------------------------------------------------------------------------

# DevOps Practices

The project follows DevOps principles:

-   Infrastructure as Code
-   Modular Terraform architecture
-   Reusable modules
-   Parameterized configuration
-   Consistent tagging strategy
-   Scalable infrastructure design

------------------------------------------------------------------------

# Possible Improvements

Future enhancements may include:

-   Remote Terraform backend using OCI Object Storage
-   CI/CD pipelines using GitHub Actions
-   OCI Monitoring and Alerts
-   Web Application Firewall (WAF)
-   Blue/Green deployment strategies
