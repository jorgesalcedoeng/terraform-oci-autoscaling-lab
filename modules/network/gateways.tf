resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.project_name}-igw"
  enabled        = true

  freeform_tags  = var.tags
}

resource "oci_core_nat_gateway" "nat" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.project_name}-nat"

  freeform_tags  = var.tags
}

resource "oci_core_service_gateway" "service_gw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.project_name}-service-gw"

  services {
    service_id = data.oci_core_services.all.services[1].id
  }

  freeform_tags = var.tags
}

data "oci_core_services" "all" {}
