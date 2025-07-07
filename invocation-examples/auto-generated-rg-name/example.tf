# =============================================================================
# Example: Auto-Generated ALZ-Compliant Resource Group Name
# =============================================================================
# This example shows how the module can auto-generate ALZ-compliant RG names

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

# Example with auto-generated RG name
module "law_auto_rg_name" {
  source = "../../"

  location = "East US 2"

  naming = {
    application_code = "MBBK"
    objective_code   = "SEGU"
    environment      = "D"
    correlative      = "01"
  }

  log_analytics_config = {
    # Resource group name will be auto-generated as: RSGEU2MBBKD01
    # (null means use computed ALZ name)
    resource_group_name = null
    
    tags = {
      Environment = "Development"
      Purpose     = "Auto-generated RG name example"
    }
  }
}

# Show what names would be generated
output "generated_names" {
  description = "Shows the auto-generated ALZ-compliant names"
  value = {
    actual_rg_name     = module.law_auto_rg_name.resource_group_name
    expected_rg_name   = module.law_auto_rg_name.resource_group_name_expected
    law_name           = module.law_auto_rg_name.log_analytics_workspace_name
    names_are_alz      = module.law_auto_rg_name.alz_names
  }
}
