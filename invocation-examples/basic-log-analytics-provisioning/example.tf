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

variable "location" {
  description = "Azure region for the workspace."
  type        = string
  default     = "eastus2"
}

variable "region_code" {
  description = "Short code for the Azure region (used in naming)."
  type        = string
  default     = "EU2"
}

variable "application_code" {
  description = "Application identifier for naming and tagging."
  type        = string
  default     = "APP"
}

variable "objective_code" {
  description = "Purpose of the workspace (e.g., monitoring, diagnostics)."
  type        = string
  default     = "CORE"
}

variable "environment" {
  description = "Environment tag (e.g., dev, test, prod)."
  type        = string
  default     = "D"
}

variable "correlative" {
  description = "Unique identifier or numeric suffix."
  type        = string
  default     = "01"
}

# Resource Group module (using Azure's official module as an example)
module "azure_rg_example_for_law" {
  source   = "git::ssh://git@github.com/landingzone-sandbox/iac-mod-az-resource-group.git"
  version  = "3.0.0"
  location = var.location
  name     = "rg-${var.region_code}-${var.application_code}-${var.environment}-${var.objective_code}-${var.correlative}"
}


module "azure_log_analytics_example" {
  source              = "git::ssh://git@github.com/landingzone-sandbox/iac-mod-az-log-analytics.git?ref=v1"
  name                = local.name
  resource_group_name = module.azure_rg_example_for_law.name
  location            = var.location
  region_code         = var.region_code
  application_code    = var.application_code
  objective_code      = var.objective_code
  environment         = var.environment
  correlative         = var.correlative
}
