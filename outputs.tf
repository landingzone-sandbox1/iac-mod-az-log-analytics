output "resource_id" {
  description = "This is the full output for the Log Analytics resource ID"
  value       = azurerm_log_analytics_workspace.this.id
}

output "log_analytics_workspace_name" {
  description = "The computed Log Analytics workspace name following ALZ naming conventions"
  value       = azurerm_log_analytics_workspace.this.name
}

output "resource_group_name" {
  description = "The computed resource group name following ALZ naming conventions"
  value       = local.resource_group_name
}