output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks.name
}

output "aks_cluster_id" {
  description = "ID of the AKS cluster"
  value       = module.aks.id
}

output "acr_login_server" {
  description = "Login server of the Azure Container Registry"
  value       = module.acr.login_server
}

output "acr_admin_username" {
  description = "Admin username of the Azure Container Registry"
  value       = module.acr.admin_username
  sensitive   = true
}

output "acr_admin_password" {
  description = "Admin password of the Azure Container Registry"
  value       = module.acr.admin_password
  sensitive   = true
}

output "application_gateway_public_ip" {
  description = "Public IP of the Application Gateway"
  value       = module.gateway.public_ip_address
}

output "kube_config" {
  description = "Kubernetes configuration"
  value       = module.aks.kube_config
  sensitive   = true
}