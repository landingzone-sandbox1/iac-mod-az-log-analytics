# Azure Log Analytics Workspace Module - Usage Models

This module supports **two distinct usage models** for deploying Azure Log Analytics Workspaces:

## Usage Model 1: ALZ-Compliant Auto-Generated RG Name (Called by RG Module)

In this model, the module generates an ALZ-compliant resource group name, but **does not create the resource group**. The calling module/root configuration is responsible for creating the RG.

### Example Usage:
```hcl
# Step 1: Calculate or get the ALZ RG name the module will generate
locals {
  region_code_map = { "East US 2" = "EU2" }
  region_code = local.region_code_map["East US 2"]
  alz_rg_name = upper("RSG${local.region_code}MBBKSEGUD01")
}

# Step 2: Create the resource group 
resource "azurerm_resource_group" "alz_compliant" {
  name     = local.alz_rg_name
  location = "East US 2"
}

# Step 3: Deploy LAW (module generates same RG name internally)
module "law" {
  source = "path/to/this/module"
  
  location = "East US 2"
  # resource_group_name = null (default) - auto-generate ALZ name
  
  naming = {
    application_code = "MBBK"
    objective_code   = "SEGU"
    environment      = "D"
    correlative      = "01"
  }
  
  log_analytics_config = { /* ... */ }
  
  depends_on = [azurerm_resource_group.alz_compliant]
}
```

### Key Points:
- `resource_group_name` is **not specified** (null/default)
- Module generates ALZ-compliant RG name: `RSG{region_code}{app_code}{obj_code}{env}{correlative}`
- **Calling module must create the RG** with the same name
- Use `module.law.resource_group_name_generated` output to verify expected name

## Usage Model 2: Standalone with Existing/Custom RG Name

In this model, you provide an existing resource group name (which may or may not follow ALZ conventions).

### Example Usage:
```hcl
# Existing RG (created elsewhere or with custom naming)
resource "azurerm_resource_group" "existing" {
  name     = "rg-shared-monitoring-prod"  # Custom naming
  location = "East US 2"
}

# Deploy LAW into existing RG
module "law" {
  source = "path/to/this/module"
  
  location            = "East US 2"
  resource_group_name = azurerm_resource_group.existing.name  # Use existing RG
  
  naming = {
    application_code = "MBBK"
    objective_code   = "SEGU" 
    environment      = "P"
    correlative      = "02"
  }
  
  log_analytics_config = { /* ... */ }
  
  depends_on = [azurerm_resource_group.existing]
}
```

### Key Points:
- `resource_group_name` is **explicitly provided**
- RG name can follow any convention (not required to be ALZ-compliant)
- **Resource group must already exist**
- Multiple LAW can be deployed to the same RG with different `objective_code` or `correlative`

## Important Notes:

1. **The module NEVER creates resource groups** - it only uses them
2. **ALZ Naming**: The LAW name always follows ALZ conventions regardless of RG naming
3. **Validation**: All inputs are validated for ALZ compliance
4. **Dependencies**: Always use `depends_on` to ensure RG exists before LAW creation

## Outputs for Validation:

- `resource_group_name`: The RG name actually used (provided or generated)
- `resource_group_name_generated`: What the ALZ-compliant RG name would be
- `log_analytics_workspace_name`: The ALZ-compliant LAW name created

## Example Directory Structure:
```
invocation-examples/
├── auto-named-rg/     # Usage Model 1 example
├── existing-rg/       # Usage Model 2 example  
└── basic-log-analytics-provisioning/  # Legacy example
```
