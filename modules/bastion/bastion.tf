resource "oci_core_instance" "bastion" {

  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_ocid

  freeform_tags = var.tags

  display_name = "${var.project_name}-bastion"
  shape        = "VM.Standard.E4.Flex"

  shape_config {

    ocpus         = 1
    memory_in_gbs = 4
  }

  create_vnic_details {

    subnet_id        = var.public_subnet_id
    assign_public_ip = true

    nsg_ids = [var.public_nsg_id]
  }

  metadata = {

    ssh_authorized_keys = file("${path.root}/oci-lab.pub")
  }

  source_details {

    source_type = "image"
    source_id   = "ocid1.image.oc1.iad.aaaaaaaabhr2qauihgil7n62c6kdpzbbtl2hbrhdsnl5oszn7azsz4xbiraa"
  }
}
