# =============================================================================
# Example 1: Simulating RG Module Creates LAW Pattern
# =============================================================================
# This simulates how an RG module would coordinate with LAW module using ALZ naming

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

# Step 1: Get expected ALZ RG name from LAW module (coordination pattern)
module "law_for_coordination" {
  source = "../../"

  location = "East US 2"

  naming = {
    application_code = "MBBK"
    objective_code   = "SEGU"
    environment      = "D"
    correlative      = "01"
  }

  log_analytics_config = {
    resource_group_name = "RSGEU2MBBKD01" # Correct ALZ RG name: RSG + EU2 + MBBK + D + 01
  }
}

# Step 2: RG Module creates RG with the ALZ name expected by LAW
resource "azurerm_resource_group" "alz_compliant" {
  name     = module.law_for_coordination.alz_names.resource_group_name
  location = "East US 2"
  tags = {
    Environment = "Development"
    ManagedBy   = "RG Module Pattern"
    Purpose     = "Created by RG module for LAW"
  }
}

# Step 3: RG Module calls LAW module with the created RG
module "law_actual" {
  source = "../../"

  location = "East US 2"

  naming = {
    application_code = "MBBK"
    objective_code   = "SEGU"
    environment      = "D"
    correlative      = "01"
  }

  log_analytics_config = {
    resource_group_name = azurerm_resource_group.alz_compliant.name

    tags = {
      Environment = "Development"
      Purpose     = "RG Module Pattern"
    }
  }

  depends_on = [azurerm_resource_group.alz_compliant]
}

# Outputs showing the coordination
output "rg_module_pattern_result" {
  description = "Shows how RG module coordinates with LAW module"
  value = {
    expected_rg_name = module.law_for_coordination.alz_names.resource_group_name
    actual_rg_name   = azurerm_resource_group.alz_compliant.name
    law_name         = module.law_actual.log_analytics_workspace_name
    names_match      = module.law_for_coordination.alz_names.resource_group_name == azurerm_resource_group.alz_compliant.name
  }
}
