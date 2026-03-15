resource "oci_load_balancer_backend_set" "backend_set" {
  load_balancer_id = oci_load_balancer_load_balancer.lb.id
  name             = "${var.project_name}-backend-set"
  policy           = "ROUND_ROBIN"

  health_checker {
    protocol = "HTTP"
    port     = 80
    url_path = "/"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    oci_load_balancer_load_balancer.lb
  ]

}
