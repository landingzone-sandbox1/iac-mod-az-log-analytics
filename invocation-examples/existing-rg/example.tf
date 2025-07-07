# =============================================================================
# Example 2: Using Existing Resource Group
# =============================================================================
# This example shows how to deploy LAW into an existing resource group

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

# Existing resource group with ALZ-compliant naming
# Existing resource group with ALZ-compliant naming
resource "azurerm_resource_group" "existing" {
  name     = "RSGEU2MBBKP01"  # ALZ-compliant: RSG + EU2 + MBBK + P + 01 (13 chars total)
  location = "East US 2"
  tags = {
    Environment = "Production"
    Purpose     = "Shared Monitoring"
    ManagedBy   = "Platform Team"
  }
}

# Log Analytics Workspace in existing RG
module "law_existing_rg" {
  source = "../../"

  location = "East US 2"
  
  naming = {
    application_code = "MBBK"
    objective_code   = "SEGU"
    environment      = "P"
    correlative      = "02"
  }

  log_analytics_config = {
    # Use existing resource group name (LAW module assumes RG exists)
    resource_group_name = azurerm_resource_group.existing.name
    
    tags = {
      Environment = "Production"
      Purpose     = "Existing RG example"
    }
  }
}

# Multiple LAWs in same RG
module "law_additional" {
  source = "../../"

  location = "East US 2"
  
  naming = {
    application_code = "MBBK"
    objective_code   = "AUDT"  # Different objective = different workspace
    environment      = "P"
    correlative      = "01"
  }

  log_analytics_config = {
    # Use same existing resource group name (LAW module assumes RG exists)
    resource_group_name = azurerm_resource_group.existing.name
    
    tags = {
      Environment = "Production"
      Purpose     = "Additional LAW in same RG"
    }
  }

  depends_on = [azurerm_resource_group.existing]
}

# Validation: Show ALZ-compliant names vs actual usage
locals {
  region_code_map = {
    "East US 2" = "EU2"
  }
  region_code = local.region_code_map["East US 2"]
  
  # What ALZ-compliant RG names would be for these workspaces (RG pattern: no objective code)
  alz_rg_name_1 = upper("RSGEU2MBBKP02")  # RSG + EU2 + MBBK + P + 02
  alz_rg_name_2 = upper("RSGEU2MBBKP01")  # RSG + EU2 + MBBK + P + 01
}

output "validation_info" {
  description = "Shows ALZ-compliant naming in use"
  value = {
    actual_rg_name           = azurerm_resource_group.existing.name
    expected_rg_pattern      = "RSGEU2MBBKP01"  # RG naming: RSG + region(3) + app(4) + env(1) + correlative(2)
    rg_name_is_alz_compliant = azurerm_resource_group.existing.name == "RSGEU2MBBKP01"
    law1_alz_name           = module.law_existing_rg.log_analytics_workspace_name
    law2_alz_name           = module.law_additional.log_analytics_workspace_name
  }
}

output "existing_rg_name" {
  value = azurerm_resource_group.existing.name
}

output "workspace1_name" {
  value = module.law_existing_rg.log_analytics_workspace_name
}

output "workspace2_name" {
  value = module.law_additional.log_analytics_workspace_name
}
