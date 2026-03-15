variable "compartment_ocid" { type = string }
variable "project_name" { type = string }
variable "public_subnet_id" { type = string }
variable "public_nsg_id" { type = string }

variable "tags" {
  type = map(string)
}
