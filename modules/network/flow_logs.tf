resource "oci_logging_log_group" "flow_logs_group" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.project_name}-flowlogs"

  freeform_tags = var.tags
}

resource "oci_logging_log" "vcn_flow_log" {

  display_name = "${var.project_name}-vcn-flow-log"
  log_group_id = oci_logging_log_group.flow_logs_group.id
  log_type     = "SERVICE"

  configuration {

    compartment_id = var.compartment_ocid

    source {
      source_type = "OCISERVICE"
      service     = "flowlogs"

      resource = oci_core_vcn.vcn.id
      category = "vcn"
    }
  }

  freeform_tags = var.tags

  is_enabled = true
}
