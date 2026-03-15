resource "oci_core_instance_configuration" "web_config" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.project_name}-web-config"

  freeform_tags = var.tags


  instance_details {

    instance_type = "compute"

    launch_details {
      compartment_id = var.compartment_ocid
      shape = "VM.Standard.E4.Flex"

      shape_config {

        ocpus         = 1
        memory_in_gbs = 4
      }

      create_vnic_details {

        subnet_id        = var.private_subnet_id
        assign_public_ip = false
        nsg_ids          = [var.private_nsg_id]

      }

      metadata = {
        ssh_authorized_keys = file("${path.root}/oci-lab.pub")
        user_data           = base64encode(file("${path.module}/user_data.yaml"))
      }

      source_details {
        source_type = "image"
        image_id    = "ocid1.image.oc1.iad.aaaaaaaabhr2qauihgil7n62c6kdpzbbtl2hbrhdsnl5oszn7azsz4xbiraa"
      }

    }
  }
}
