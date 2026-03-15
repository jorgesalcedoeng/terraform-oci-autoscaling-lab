resource "oci_core_route_table" "public_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.project_name}-public-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.igw.id
  }

  freeform_tags = var.tags

}

resource "oci_core_route_table" "private_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.project_name}-private-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_nat_gateway.nat.id
  }

  freeform_tags = var.tags

}
