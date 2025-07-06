# =============================================================================
# Example 1: Using Auto-Generated ALZ Resource Group Name
# =============================================================================
# This example shows how to let the module generate the RG name automatically

terraform {
  required_version = "~> 1.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.28"
    }
  }
}

provider "azurerm" {
  features {}
}

# Step 1: Get the ALZ-compliant RG name that the module would generate
locals {
  # Manual calculation of ALZ RG name (should match module's logic)
  region_code_map = {
    "East US 2" = "EU2"
  }
  region_code = local.region_code_map["East US 2"]
  alz_rg_name = upper("RSG${local.region_code}MBBKSEGUD01")
}

# Step 2: Create the resource group with ALZ-compliant name
resource "azurerm_resource_group" "auto_named" {
  name     = local.alz_rg_name
  location = "East US 2"
  tags = {
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}

# Step 3: Log Analytics Workspace using auto-generated RG name logic
module "law_auto" {
  source = "../../"

  location = "East US 2"
  # Don't specify resource_group_name - let it auto-generate (should match local.alz_rg_name)

  naming = {
    application_code = "MBBK"
    objective_code   = "SEGU"
    environment      = "D"
    correlative      = "01"
  }

  log_analytics_config = {
    tags = {
      Environment = "Development"
      Purpose     = "Auto-named example"
    }
  }

  depends_on = [azurerm_resource_group.auto_named]
}

# Validation: Ensure the module generates the same RG name we created
output "validation_rg_names_match" {
  description = "Validates that our manual RG name calculation matches the module's"
  value = {
    manual_rg_name    = local.alz_rg_name
    module_rg_name    = module.law_auto.resource_group_name
    names_match       = local.alz_rg_name == module.law_auto.resource_group_name
  }
}

output "law_resource_id" {
  description = "The created Log Analytics Workspace resource ID"
  value       = module.law_auto.resource_id
}

output "auto_rg_name" {
  value = module.law_auto.resource_group_name
}

output "auto_workspace_name" {
  value = module.law_auto.log_analytics_workspace_name
}
