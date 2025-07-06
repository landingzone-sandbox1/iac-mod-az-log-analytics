output "resource_id" {
  description = "This is the full output for the Log Analytics resource ID"
  value       = azurerm_log_analytics_workspace.this.id
}

output "log_analytics_workspace_name" {
  description = "The computed Log Analytics workspace name following ALZ naming conventions"
  value       = azurerm_log_analytics_workspace.this.name
}

output "resource_group_name" {
  description = "The resource group name used for the Log Analytics Workspace"
  value       = local.resource_group_name
}

output "resource_group_name_expected" {
  description = "The ALZ-compliant resource group name that should be used (for RG module reference)"
  value       = local.resource_group_name_generated
}

output "alz_names" {
  description = "ALZ-compliant names for both RG and LAW (for RG module coordination)"
  value = {
    resource_group_name          = local.resource_group_name_generated
    log_analytics_workspace_name = local.log_analytics_workspace_name
  }
}