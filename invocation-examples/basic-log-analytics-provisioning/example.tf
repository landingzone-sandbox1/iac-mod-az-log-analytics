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
#   - tags: Optional metadata tags.
# Variables not sent:
#   - name: The workspace name is derived within the module.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}


# Resource Group module (using Azure's official module as an example)
module "azure_rg_example_for_law" {
  source   = "git::ssh://git@github.com/landingzone-sandbox/iac-mod-az-resource-group.git"
  location         = var.location
  application_code = var.application_code
  region_code      = var.region_code
  correlative      = var.correlative
  environment      = var.environment
  tags             = var.tags
}


module "azure_log_analytics_example" {
  source              = "git::ssh://git@github.com/landingzone-sandbox/iac-mod-az-log-analytics.git"
  resource_group_name = module.azure_rg_example_for_law.name
  location            = var.location
  region_code         = var.region_code
  application_code    = var.application_code
  environment         = var.environment
  correlative         = var.correlative
  objective_code      = var.objective_code
  tags                = var.tags

  log_analytics_workspace_allow_resource_only_permissions = var.log_analytics_workspace_allow_resource_only_permissions
  log_analytics_workspace_cmk_for_query_forced            = var.log_analytics_workspace_cmk_for_query_forced
  log_analytics_workspace_internet_ingestion_enabled      = var.log_analytics_workspace_internet_ingestion_enabled
  log_analytics_workspace_internet_query_enabled          = var.log_analytics_workspace_internet_query_enabled
}

# -----------------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------------

output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics Workspace."
  value       = module.azure_log_analytics_workspace.resource_id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace."
  value       = module.azure_log_analytics_workspace.log_analytics_workspace_name
}