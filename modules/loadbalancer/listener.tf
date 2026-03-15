resource "oci_load_balancer_listener" "http_listener" {
  load_balancer_id         = oci_load_balancer_load_balancer.lb.id
  name                     = "listener-http"
  default_backend_set_name = oci_load_balancer_backend_set.backend_set.name
  port                     = 80
  protocol                 = "HTTP"

  depends_on = [
    oci_load_balancer_backend_set.backend_set
  ]

}
