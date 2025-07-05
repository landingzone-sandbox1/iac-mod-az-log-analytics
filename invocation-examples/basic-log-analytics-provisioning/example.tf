# Use case name: Basic Azure Log Analytics Workspace Provisioning
# Description: Example of how to provision a Log Analytics Workspace using the module with default configuration.
# When to apply: Use when centralized log collection and analytics are needed for monitoring and diagnostics.
# Considerations:
#   - Requires that the resource group is created beforehand.
#   - This example demonstrates basic provisioning with minimal configuration.
#   - The name of the workspace is auto-generated using standard naming logic within the module.
#   - Ensure the region supports Log Analytics.
#   - Network and RBAC settings are optional but recommended for production environments.

terraform {
  required_version = "~> 1.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.28"
    }
  }
}

provider "azurerm" {
  features {}
}

# Azure context data source
data "azurerm_client_config" "current" {}

# Resource Group module
module "azure_rg_example_for_law" {
  source           = "git::ssh://git@github.com/landingzone-sandbox/iac-mod-az-resource-group.git"
  location         = var.location
  application_code = var.application_code
  region_code      = var.region_code
  correlative      = var.correlative
  environment      = var.environment
  tags             = var.tags
  name             = local.resource_group_name
}

# Example Log Analytics Workspace deployment
module "azure_log_analytics_example" {
  source = "../../"

  # Required variables
  location            = var.location
  application_code    = var.application_code
  objective_code      = var.objective_code
  environment         = var.environment
  correlative         = var.correlative
  resource_group_name = module.azure_rg_example_for_law.name

  # Optional variables with recommended defaults
  log_analytics_workspace_allow_resource_only_permissions = false
  log_analytics_workspace_cmk_for_query_forced            = false
  log_analytics_workspace_internet_ingestion_enabled      = false
  log_analytics_workspace_internet_query_enabled          = false

  # Optional configurations
  log_analytics_workspace_identity = {
    type = "SystemAssigned"
  }

  # Optional timeouts
  log_analytics_workspace_timeouts = {
    create = "30m"
    delete = "30m"
    read   = "5m"
    update = "30m"
  }

  # Tags
  tags = var.tags

  # Role assignments (optional)
  role_assignments = {
    # Example role assignment for the current user/service principal
    "current_user_contributor" = {
      role_definition_id_or_name = "Log Analytics Contributor"
      principal_id               = data.azurerm_client_config.current.object_id
      principal_type             = "ServicePrincipal"
      description                = "Contributor access for current user"
    }
  }
}

# Input variables
variable "location" {
  description = "Azure region for the workspace."
  type        = string
  default     = "eastus2"
}

variable "application_code" {
  description = "4-character application code, uppercase alphanumeric (e.g., AP01 for Application 01)."
  type        = string
  default     = "AP01"
}

variable "objective_code" {
  description = "A 3 to 4 character code conveying a meaningful purpose for the resource (e.g., core, mgmt, segu)."
  type        = string
  default     = "MON"
}

variable "environment" {
  description = "The environment for deployment (e.g., D, P, C)."
  type        = string
  default     = "D"
}

variable "correlative" {
  description = "An optional correlative ID to differentiate between similar resources."
  type        = string
  default     = "01"
}

variable "tags" {
  description = "Optional metadata tags."
  type        = map(string)
  default = {
    Environment = "Development"
    Purpose     = "Log Analytics Example"
    ManagedBy   = "Terraform"
  }
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
