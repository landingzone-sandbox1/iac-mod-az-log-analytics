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
  subscription_id = "0bd8fd8a-69f4-4d31-b498-fd04e55a6567" # Current subscription
}

# Azure context data source
data "azurerm_client_config" "current" {}

# Create the resource group first (following ALZ RG naming convention)
resource "azurerm_resource_group" "example" {
  name     = upper("RSG${lookup(local.location_to_region_code, var.location, "EU2")}${var.application_code}${var.environment}${var.correlative}")
  location = var.location
  tags     = var.tags
}

# Local values for region mapping (matching main module)
locals {
  location_to_region_code = {
    # USA - Long forms (display names)
    "East US"              = "EU1"
    "East US 2"            = "EU2" 
    "Central US"           = "CU1"
    "North Central US"     = "NCU"
    "South Central US"     = "SCU"
    "West US"              = "WU1"
    "West US 2"            = "WU2"
    "West US 3"            = "WU3"
    "Canada Central"       = "CC1"
    "Canada East"          = "CE1"
    "Brazil South"         = "BS1"
    "Brazil Southeast"     = "BSE"
    "Mexico Central"       = "MC1"
    "Chile Central"        = "CL1"
  }
}

# Example Log Analytics Workspace deployment
module "azure_log_analytics_example" {
  source = "../../"

  # Required variables
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name

  # Naming configuration
  naming = {
    application_code = var.application_code
    objective_code   = var.objective_code
    environment      = var.environment
    correlative      = var.correlative
  }

  # Log Analytics configuration
  log_analytics_config = {
    # Resource Group configuration  
    resource_group_name = azurerm_resource_group.example.name
    # Security settings (secure defaults)
    allow_resource_only_permissions = false
    cmk_for_query_forced            = false
    internet_ingestion_enabled      = false
    internet_query_enabled          = false

    # Managed identity configuration
    identity = {
      type = "SystemAssigned"
    }

    # Operational settings
    timeouts = {
      create = "30m"
      delete = "30m"
      read   = "5m"
      update = "30m"
    }

    # Resource tags
    tags = var.tags

    # RBAC role assignments with least-privilege enforcement
    role_assignments = {
      # Example: Grant Log Analytics Reader access to a service principal
      "monitoring_reader" = {
        role_definition_id_or_name = "Log Analytics Reader"
        principal_id               = data.azurerm_client_config.current.object_id
        principal_type             = "ServicePrincipal"
        description                = "Read-only access for monitoring"
      }
    }
  }
}

# Input variables
variable "location" {
  description = "Azure region for the workspace."
  type        = string
  default     = "East US 2" # Must match a region in local.location_to_region_code
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
output "resource_group_name" {
  description = "Name of the created resource group."
  value       = azurerm_resource_group.example.name
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics Workspace."
  value       = module.azure_log_analytics_example.resource_id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace."
  value       = module.azure_log_analytics_example.log_analytics_workspace_name
}
