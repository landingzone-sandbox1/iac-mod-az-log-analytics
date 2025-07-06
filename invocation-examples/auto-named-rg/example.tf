# =============================================================================
# Example: Standalone LAW with ALZ-Compliant Manual RG Creation
# =============================================================================
# This shows how to create an ALZ-compliant RG and deploy LAW into it

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

# First, get the expected ALZ RG name from LAW module
module "law_naming_check" {
  source = "../../"

  location            = "East US 2"
  resource_group_name = "RSGEU2MBBKD01"  # ALZ-compliant RG name: RSG + EU2 + MBBK + D + 01

  naming = {
    application_code = "MBBK"
    objective_code   = "SEGU"
    environment      = "D"
    correlative      = "01"
  }

  log_analytics_config = {}
}

# Create ALZ-compliant resource group manually
resource "azurerm_resource_group" "alz_compliant" {
  name     = module.law_naming_check.resource_group_name_expected
  location = "East US 2"
  tags = {
    Environment = "Development"
    Purpose     = "ALZ-compliant standalone RG for LAW"
  }
}

# Deploy LAW into the created RG
module "law_standalone" {
  source = "../../"

  location            = "East US 2"
  resource_group_name = azurerm_resource_group.alz_compliant.name

  naming = {
    application_code = "MBBK"
    objective_code   = "SEGU"
    environment      = "D"
    correlative      = "01"
  }

  log_analytics_config = {
    tags = {
      Environment = "Development"
      Purpose     = "Standalone LAW with manual ALZ RG"
    }
  }

  depends_on = [azurerm_resource_group.alz_compliant]
}

# Validation outputs - show the ALZ coordination
output "alz_coordination_info" {
  description = "Shows ALZ-compliant naming coordination"
  value = {
    expected_rg_name = module.law_naming_check.resource_group_name_expected
    actual_rg_name   = azurerm_resource_group.alz_compliant.name
    law_name         = module.law_standalone.log_analytics_workspace_name
    names_match      = module.law_naming_check.resource_group_name_expected == azurerm_resource_group.alz_compliant.name
  }
}
