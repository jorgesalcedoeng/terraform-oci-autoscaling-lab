resource "oci_autoscaling_auto_scaling_configuration" "web_autoscaling" {

  compartment_id = var.compartment_ocid
  display_name   = "${var.project_name}-autoscaling-config"

  freeform_tags = var.tags

  cool_down_in_seconds = 300

  auto_scaling_resources {
    id   = var.instance_pool_id
    type = "instancePool"
  }

  policies {

    display_name = "cpu-autoscaling-policy"
    policy_type  = "threshold"

    capacity {
      initial = 2
      min     = 2
      max     = 5
    }

    rules {
      display_name = "scale-out-cpu"
      action {
        type  = "CHANGE_COUNT_BY"
        value = 1
      }

      metric {
        metric_type = "CPU_UTILIZATION"
        threshold {
          operator = "GT"
          value    = 70
        }
      }
    }

    rules {
      display_name = "scale-in-cpu"
      action {
        type  = "CHANGE_COUNT_BY"
        value = -1
      }

      metric {
        metric_type = "CPU_UTILIZATION"
        threshold {
          operator = "LT"
          value    = 30
        }
      }
    }
  }
}
