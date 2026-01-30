output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "aks_subnet_id" {
  description = "ID of the AKS subnet"
  value       = azurerm_subnet.aks.id
}

output "gateway_subnet_id" {
  description = "ID of the gateway subnet"
  value       = azurerm_subnet.gateway.id
}