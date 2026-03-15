resource "oci_core_instance_pool" "web_pool" {

  compartment_id            = var.compartment_ocid
  instance_configuration_id = oci_core_instance_configuration.web_config.id
  size                      = 2

  placement_configurations {
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    primary_subnet_id   = var.private_subnet_id
  }

  load_balancers {
    backend_set_name = var.backend_set_name
    load_balancer_id = var.load_balancer_id
    port             = 80
    vnic_selection   = "PrimaryVnic"
  }

  freeform_tags = var.tags
}

