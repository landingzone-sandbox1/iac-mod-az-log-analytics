# Use case name: Basic Azure Log Analytics Workspace Provisioning
# Description: Example of how to provision a Log Analytics Workspace using the module with default configuration.
# When to apply: Use when centralized log collection and analytics are needed for monitoring and diagnostics.
# Considerations:
#   - Requires that the resource group is created beforehand.
#   - This example does not configure data retention, solutions, or linked services — only base provisioning.
#   - The name of the workspace is auto-generated using standard naming logic within the module.
#   - Ensure the region supports Log Analytics.
#   - Variables defined in locals are surfaced below and passed to modules as needed.
# Variables used:
#   - location: Azure region for the workspace.
#   - region_code: Short code for the Azure region (used in naming).
#   - application_code: Application identifier for naming and tagging.
#   - objective_code: Purpose of the workspace (e.g., monitoring, diagnostics).
#   - environment: Environment tag (e.g., dev, test, prod).
#   - correlative: Unique identifier or numeric suffix.
#   - tags: Optional metadata tags.
#   - log_analytics_workspace_allow_resource_only_permissions: Allow resource-only permissions (bool).
#   - log_analytics_workspace_cmk_for_query_forced: Force CMK for query (bool).
#   - log_analytics_workspace_internet_ingestion_enabled: Enable internet ingestion (bool).
#   - log_analytics_workspace_internet_query_enabled: Enable internet query (bool).
#   - log_analytics_workspace_sku: Workspace SKU (from locals).
#   - log_analytics_workspace_daily_quota_gb: Daily quota in GB (from locals).
#   - log_analytics_workspace_retention_in_days: Retention in days (from locals).
#   - log_analytics_workspace_local_authentication_disabled: Disable local auth (from locals).
#   - name: The workspace name (from locals).
#   - resource_group_name: The resource group name (from locals).

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

# Azure context data source
data "azurerm_client_config" "current" {}

# Locals block for values from local.tf
variable "region_code" {
  description = "Short code representing the Azure region (e.g., eus2 for East US 2)."
  type        = string
}
variable "application_code" {
  description = "Short application code used in naming convention."
  type        = string
}
variable "objective_code" {
  description = "A 3 to 4 character code conveying a meaningful purpose for the resource (e.g., core, mgmt)."
  type        = string
}
variable "environment" {
  description = "The environment for deployment (e.g., D, P, C)."
  type        = string
}
variable "correlative" {
  description = "An optional correlative ID to differentiate between similar resources."
  type        = string
  default     = "01"
}

locals {
  service_code                                          = "LAW"
  service_code_rg                                       = "RSG"
  region_code                                           = "eus2"
  application_code                                      = "AP01"
  objective_code                                        = "MON"
  environment                                           = "D"
  correlative                                           = "01"
  name                                                  = "${local.service_code}${local.region_code}${local.application_code}${local.objective_code}${local.environment}${local.correlative}"
  resource_group_name                                   = "${local.service_code_rg}${local.region_code}${local.application_code}${local.environment}${local.correlative}"
  log_analytics_workspace_sku                           = "PerGB2018"
  log_analytics_workspace_daily_quota_gb                = -1
  log_analytics_workspace_retention_in_days             = var.objective_code == "SEGU" ? 365 : 90
  log_analytics_workspace_local_authentication_disabled = true
}

# Resource Group module
module "azure_rg_example_for_law" {
  source            = "git::ssh://git@github.com/landingzone-sandbox/iac-mod-az-resource-group.git"
  location          = var.location
  application_code  = var.application_code
  region_code       = var.region_code
  correlative       = var.correlative
  environment       = var.environment
  tags              = var.tags
  name              = local.resource_group_name
}

module "azure_log_analytics_example" {
  source                                         = "git::ssh://git@github.com/landingzone-sandbox/iac-mod-az-log-analytics.git"
  resource_group_name                            = module.azure_rg_example_for_law.name
  location                                       = var.location
  region_code                                    = var.region_code
  application_code                               = var.application_code
  environment                                    = var.environment
  correlative                                    = var.correlative
  objective_code                                 = var.objective_code


  tags                                           = var.tags
  name                                           = local.name
  log_analytics_workspace_sku                    = local.log_analytics_workspace_sku
  log_analytics_workspace_daily_quota_gb         = local.log_analytics_workspace_daily_quota_gb
  log_analytics_workspace_retention_in_days      = local.log_analytics_workspace_retention_in_days
  log_analytics_workspace_local_authentication_disabled = local.log_analytics_workspace_local_authentication_disabled
  log_analytics_workspace_allow_resource_only_permissions = var.log_analytics_workspace_allow_resource_only_permissions
  log_analytics_workspace_cmk_for_query_forced   = var.log_analytics_workspace_cmk_for_query_forced
  log_analytics_workspace_internet_ingestion_enabled = var.log_analytics_workspace_internet_ingestion_enabled
  log_analytics_workspace_internet_query_enabled = var.log_analytics_workspace_internet_query_enabled
}

# Outputs
output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics Workspace."
  value       = module.azure_log_analytics_example.resource_id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace."
  value       = module.azure_log_analytics_example.log_analytics_workspace_name
}