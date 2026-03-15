variable "compartment_ocid" { type = string }
variable "project_name" { type = string }
variable "private_subnet_id" { type = string }
variable "private_nsg_id" { type = string }
variable "public_nsg_id" { type = string }
variable "public_subnet_id" { type = string }

variable "tags" {
  type = map(string)
}

variable "load_balancer_id" { type = string }
variable "backend_set_name" { type = string }
