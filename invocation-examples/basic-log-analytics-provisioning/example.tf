# Repository: https://github.com/landingzone-sandbox/iac-deploy-tf-az-example-log-analytics
#
# Use case name: Basic Azure Log Analytics Workspace Provisioning
# Description: Example of how to provision a Log Analytics Workspace using the module with default configuration.
# When to use: Use when centralized log collection and analytics are needed for monitoring and diagnostics.
# Considerations:
#   - Requires that the resource group is created beforehand.
#   - This example does not configure data retention, solutions, or linked services — only base provisioning.
#   - The name of the workspace is auto-generated using standard naming logic within the module.
#   - Ensure the region supports Log Analytics.
# Variables sent:
#   - location: Azure region for the workspace.
#   - resource_group_name: Name of the previously created resource group.
#   - region_code: Short code for the Azure region (used in naming).
#   - application_code: Application identifier for naming and tagging.
#   - objective_code: Purpose of the workspace (e.g., monitoring, diagnostics).
#   - environment: Environment tag (e.g., dev, test, prod).
#   - correlative: Unique identifier or numeric suffix.
# Variables not sent:
#   - name: The workspace name is derived within the module.

module "azure_log_analytics_example" {
  source              = "git::ssh://git@github.com/landingzone-sandbox/iac-mod-az-log-analytics.git?ref=v1"
  location            = var.location
  resource_group_name = module.azure_rg_example_for_law.name
  region_code         = var.region_code
  application_code    = var.application_code
  objective_code      = var.objective_code
  environment         = var.environment
  correlative         = var.correlative
}
