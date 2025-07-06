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

# Existing resource group (could be created elsewhere or already exist)
resource "azurerm_resource_group" "existing" {
  name     = "rg-shared-monitoring-prod"  # User's own naming convention
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

  location            = "East US 2"
  resource_group_name = azurerm_resource_group.existing.name  # Use existing RG

  naming = {
    application_code = "MBBK"
    objective_code   = "SEGU"
    environment      = "P"
    correlative      = "02"
  }

  log_analytics_config = {
    tags = {
      Environment = "Production"
      Purpose     = "Existing RG example"
    }
  }
}

# Multiple LAWs in same RG
module "law_additional" {
  source = "../../"

  location            = "East US 2"
  resource_group_name = azurerm_resource_group.existing.name  # Same RG

  naming = {
    application_code = "MBBK"
    objective_code   = "AUDT"  # Different objective = different workspace
    environment      = "P"
    correlative      = "01"
  }

  log_analytics_config = {
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
  
  # What ALZ-compliant names would be for these workspaces
  alz_rg_name_1 = upper("RSG${local.region_code}MBBKSEGUP02")
  alz_rg_name_2 = upper("RSG${local.region_code}MBBKAUDTP01")
}

output "validation_info" {
  description = "Shows the difference between ALZ naming and custom naming"
  value = {
    actual_rg_name          = azurerm_resource_group.existing.name
    alz_compliant_rg_name_1 = local.alz_rg_name_1
    alz_compliant_rg_name_2 = local.alz_rg_name_2
    using_custom_naming     = true
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
