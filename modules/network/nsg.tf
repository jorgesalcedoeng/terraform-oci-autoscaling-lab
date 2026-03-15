resource "oci_core_network_security_group" "public_nsg" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.project_name}-public-nsg"

  freeform_tags = var.tags
}

resource "oci_core_network_security_group" "private_nsg" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.project_name}-private-nsg"

  freeform_tags = var.tags
  
}

resource "oci_core_network_security_group_security_rule" "ssh" {
  network_security_group_id = oci_core_network_security_group.public_nsg.id
  direction = "INGRESS"
  protocol  = "6"
  source    = "0.0.0.0/0"

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_network_security_group_security_rule" "ssh_private" {
  network_security_group_id = oci_core_network_security_group.private_nsg.id
  direction = "INGRESS"
  protocol  = "6"
  source    = "0.0.0.0/0"

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
  
}

resource "oci_core_network_security_group_security_rule" "http" {
  network_security_group_id = oci_core_network_security_group.public_nsg.id
  direction = "INGRESS"
  protocol  = "6"
  source    = "0.0.0.0/0"

  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "http_private" {
  network_security_group_id = oci_core_network_security_group.private_nsg.id
  direction = "INGRESS"
  protocol  = "6"
  source    = "0.0.0.0/0"

  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
  
}

resource "oci_core_network_security_group_security_rule" "allow_all_egress" {
  network_security_group_id = oci_core_network_security_group.public_nsg.id

  direction   = "EGRESS"
  protocol    = "all"
  destination = "0.0.0.0/0"

  description = "Allow all outbound traffic"
}

resource "oci_core_network_security_group_security_rule" "allow_all_egress_private" {
  network_security_group_id = oci_core_network_security_group.private_nsg.id

  direction   = "EGRESS"
  protocol    = "all"
  destination = "0.0.0.0/0"

  description = "Allow all outbound traffic"
}
