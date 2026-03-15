resource "oci_core_subnet" "public_subnet" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  cidr_block     = var.public_subnet_cidr
  display_name   = "${var.project_name}-public-subnet"

  route_table_id = oci_core_route_table.public_rt.id
  security_list_ids = [oci_core_security_list.public_sl.id]
  prohibit_public_ip_on_vnic = false

  freeform_tags = var.tags
}

resource "oci_core_subnet" "private_subnet" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  cidr_block     = var.private_subnet_cidr
  display_name   = "${var.project_name}-private-subnet"

  route_table_id = oci_core_route_table.private_rt.id
  security_list_ids = [oci_core_security_list.private_sl.id]
  prohibit_public_ip_on_vnic = true

  freeform_tags = var.tags
}
