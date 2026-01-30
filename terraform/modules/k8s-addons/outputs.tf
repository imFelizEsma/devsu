output "nginx_ingress_ip" {
  description = "External IP of NGINX Ingress Controller"
  value       = helm_release.nginx_ingress.status[0].load_balancer[0].ingress[0].ip
}