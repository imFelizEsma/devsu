output "id" {
  description = "ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.id
}

output "workspace_id" {
  description = "Workspace ID"
  value       = azurerm_log_analytics_workspace.main.workspace_id
}