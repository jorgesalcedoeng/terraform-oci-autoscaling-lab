resource "oci_load_balancer_load_balancer" "lb" {
  compartment_id             = var.compartment_ocid
  display_name               = "${var.project_name}-lb"
  shape                      = "flexible"
  network_security_group_ids = [var.public_nsg_id]

  shape_details {
    minimum_bandwidth_in_mbps = 10
    maximum_bandwidth_in_mbps = 100
  }

  lifecycle {
    create_before_destroy = true
  }

  subnet_ids = [var.public_subnet_id]

  is_private = false

  freeform_tags = var.tags

}

