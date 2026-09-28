// MARK: - Load Balancer 식별자

output "load_balancer_no" {
  description = "Public Application Load Balancer identifier"
  value       = ncloud_lb.web.id
}

output "load_balancer_domain" {
  description = "Public domain assigned to the Application Load Balancer"
  value       = ncloud_lb.web.domain
}

output "target_group_no" {
  description = "Web target group identifier"
  value       = ncloud_lb_target_group.web.id
}

output "http_listener_no" {
  description = "HTTP listener identifier"
  value       = ncloud_lb_listener.http.id
}