resource "oci_core_vcn" "vcn" {
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_ocid
  display_name   = "${var.project_name}-vcn"
  dns_label      = "mainvcn"

  freeform_tags  = var.tags
}
