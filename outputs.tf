output "resource_id" {
  description = "This is the full output for the Log Analytics resource ID. This is the default output for the module following AVM standards. Review the examples below for the correct output to use in your module."
  value       = azurerm_log_analytics_workspace.this.id
}

output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.this.name
}