# OCI Autoscaling Infrastructure with Terraform

![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.5-623CE4?logo=terraform)
![OCI](https://img.shields.io/badge/Oracle%20Cloud-Infrastructure-F80000?logo=oracle)
![IaC](https://img.shields.io/badge/Infrastructure-as-Code-blue)
![DevOps](https://img.shields.io/badge/DevOps-Automation-orange)
![License](https://img.shields.io/badge/license-MIT-green)

------------------------------------------------------------------------

# Overview

This repository contains a **modular Terraform implementation for
deploying scalable infrastructure in Oracle Cloud Infrastructure
(OCI)**.

The project provisions a **production-ready environment** including:

-   Virtual Cloud Network (VCN)
-   Public and Private Subnets
-   Internet and NAT Gateways
-   Bastion Host for secure access
-   Load Balancer
-   Compute Instance Pool
-   Autoscaling Policies
-   Network Security Groups

The infrastructure is designed following **Infrastructure as Code (IaC),
DevOps and Cloud Architecture best practices**.

------------------------------------------------------------------------

# Architecture

The architecture deploys a **highly available autoscaling compute layer
behind a public load balancer**.

                            Internet
                               │
                               ▼
                     ┌────────────────────┐
                     │   OCI Load Balancer │
                     │      (Public)       │
                     └─────────┬───────────┘
                               │
                     ┌─────────▼─────────┐
                     │   Instance Pool   │
                     │  Auto Scaling     │
                     │ (Private Subnet)  │
                     └─────────┬─────────┘
                               │
                     ┌─────────▼─────────┐
                     │   Private Network │
                     │   Security Groups │
                     └───────────────────┘

                ┌───────────────────────────────┐
                │ Bastion Host (Public Subnet)  │
                │ Secure SSH Access             │
                └───────────────────────────────┘

------------------------------------------------------------------------

# Project Structure

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
    │
    │   ├── network/
    │   │   ├── vcn.tf
    │   │   ├── subnets.tf
    │   │   ├── gateways.tf
    │   │   ├── routes.tf
    │   │   ├── nsg.tf
    │   │   └── flow_logs.tf
    │   │
    │   ├── compute/
    │   │   ├── instance_configuration.tf
    │   │   ├── instance_pool.tf
    │   │   └── user_data.yaml
    │   │
    │   ├── loadbalancer/
    │   │   ├── loadbalancer.tf
    │   │   ├── backendset.tf
    │   │   └── listener.tf
    │   │
    │   ├── autoscaling/
    │   │   └── autoscaling.tf
    │   │
    │   └── bastion/
    │       └── bastion.tf
    │
    └── README.md

------------------------------------------------------------------------

# Modules Description

  Module         Description
  -------------- ---------------------------------------------------------
  network        Creates VCN, subnets, routing tables, gateways and NSGs
  compute        Deploys instance configuration and instance pool
  loadbalancer   Creates OCI Load Balancer and backend configuration
  autoscaling    Defines autoscaling policies for instance pools
  bastion        Deploys bastion host for secure remote access

------------------------------------------------------------------------

# Requirements

  Tool           Version
  -------------- -------------
  Terraform      \>= 1.5
  OCI Provider   \>= 5.0
  OCI CLI        Recommended

------------------------------------------------------------------------

# OCI Provider Configuration

Terraform uses the **OCI CLI configuration file** for authentication.

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

  ------------------------------------------------------------------------
  Variable              Description                        Type
  --------------------- ---------------------------------- ---------------
  compartment_ocid      OCI compartment where resources    string
                        will be deployed                   

  project_name          Resource naming prefix             string

  vcn_cidr              CIDR block for the VCN             string

  public_subnet_cidr    CIDR block for public subnet       string

  private_subnet_cidr   CIDR block for private subnet      string

  instance_shape        Compute instance shape             string

  instance_count        Initial number of instances        number

  tags                  Resource tags                      map(string)
  ------------------------------------------------------------------------

Example:

``` hcl
project_name = "oci-autoscaling-lab"
vcn_cidr = "10.0.0.0/16"
```

------------------------------------------------------------------------

# Outputs

  Output              Description
  ------------------- ----------------------------
  vcn_id              ID of created VCN
  public_subnet_id    Public subnet identifier
  private_subnet_id   Private subnet identifier
  load_balancer_ip    Public IP of load balancer
  instance_pool_id    Instance pool identifier

------------------------------------------------------------------------

# Deployment Guide

## 1. Clone repository

``` bash
git clone https://github.com/your-org/oci-autoscaling.git
cd oci-autoscaling
```

## 2. Initialize Terraform

``` bash
terraform init
```

## 3. Validate configuration

``` bash
terraform validate
```

## 4. Review execution plan

``` bash
terraform plan
```

## 5. Deploy infrastructure

``` bash
terraform apply
```

------------------------------------------------------------------------

# Autoscaling Strategy

Autoscaling is implemented using **OCI Instance Pools and Autoscaling
Policies**.

  Metric                   Action
  ------------------------ -----------
  CPU Utilization \> 70%   Scale Out
  CPU Utilization \< 30%   Scale In

Benefits:

-   Elastic infrastructure
-   Cost optimization
-   High availability

------------------------------------------------------------------------

# Security Best Practices

The infrastructure implements multiple security controls:

-   Private subnet for compute nodes
-   Public exposure only via load balancer
-   Bastion host for controlled SSH access
-   Network Security Groups
-   Flow logs for monitoring

------------------------------------------------------------------------

# DevOps Best Practices Implemented

-   Infrastructure as Code
-   Modular Terraform design
-   Reusable infrastructure modules
-   Parameterized configuration
-   Tagging strategy
-   Scalable compute architecture

------------------------------------------------------------------------

# Future Improvements

Possible enhancements:

-   Remote Terraform backend using OCI Object Storage
-   CI/CD pipeline using GitHub Actions
-   OCI Monitoring and alarms
-   Web Application Firewall (WAF)
-   Blue/Green deployments

------------------------------------------------------------------------

# Author

Jorge Salcedo
Cloud Solution Architect

