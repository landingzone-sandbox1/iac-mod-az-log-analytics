output "resource_id" {
  description = "This is the full output for the Log Analytics resource ID"
  value       = azurerm_log_analytics_workspace.this.id
}

output "log_analytics_workspace_name" {
  description = "The computed Log Analytics workspace name following ALZ naming conventions"
  value       = azurerm_log_analytics_workspace.this.name
}

output "resource_group_name" {
  description = "The resource group name used for the Log Analytics Workspace (provided or auto-generated)"
  value       = local.resource_group_name
}

output "resource_group_name_generated" {
  description = "The ALZ-compliant resource group name that would be auto-generated"
  value       = upper("${local.service_code_rsg}${local.region_code}${local.application_code}${local.objective_code}${local.environment}${local.correlative}")
}