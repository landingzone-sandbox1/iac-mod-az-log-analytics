locals {
  # Map Azure location to region_code for Americas (USA, Canada, etc.)
  # Supports both normalized form (eastus2) and long form (East US 2)
  # Uses 3-character region codes to maintain compatibility with child modules
  location_to_region_code = {
    # USA - Normalized forms
    "eastus"              = "EU1"
    "eastus2"             = "EU2"
    "centralus"           = "CU1"
    "northcentralus"      = "NCU"
    "southcentralus"      = "SCU"
    "westus"              = "WU1"
    "westus2"             = "WU2"
    "westus3"             = "WU3"
    "southcentralusstage" = "SCS"

    # USA - Long forms (display names)
    "East US"                = "EU1"
    "East US 2"              = "EU2"
    "Central US"             = "CU1"
    "North Central US"       = "NCU"
    "South Central US"       = "SCU"
    "West US"                = "WU1"
    "West US 2"              = "WU2"
    "West US 3"              = "WU3"
    "South Central US Stage" = "SCS"

    # Canada - Normalized forms
    "canadacentral" = "CC1"
    "canadaeast"    = "CE1"

    # Canada - Long forms
    "Canada Central" = "CC1"
    "Canada East"    = "CE1"

    # Brazil - Normalized forms
    "brazilsouth"     = "BS1"
    "brazilsoutheast" = "BSE"

    # Brazil - Long forms
    "Brazil South"     = "BS1"
    "Brazil Southeast" = "BSE"

    # Mexico - Normalized forms
    "mexicocentral" = "MC1"

    # Mexico - Long forms
    "Mexico Central" = "MC1"

    # Chile - Normalized forms
    "chilecentral" = "CL1"

    # Chile - Long forms
    "Chile Central" = "CL1"
  }


  service_code     = "LAW"
  service_code_rsg = "RSG"
  application_code = var.naming.application_code
  objective_code   = var.naming.environment == "F" ? "SEGU" : var.naming.objective_code
  environment      = var.naming.environment
  correlative      = var.naming.correlative
  region_code      = lookup(local.location_to_region_code, var.location, "EU2")

  # Always construct both names for ALZ compliance
  log_analytics_workspace_name = lower("${local.service_code}${local.region_code}${local.application_code}${local.objective_code}${local.environment}${local.correlative}")
  # RG naming: RSG + Region(3) + App(4) + Env(1) + Correlative(2) - NO objective code
  resource_group_name_generated = upper("${local.service_code_rsg}${local.region_code}${local.application_code}${local.environment}${local.correlative}")

  # Smart merge: Use provided RG name if given, otherwise use computed ALZ-compliant name
  resource_group_name = coalesce(
    var.log_analytics_config.resource_group_name,
    local.resource_group_name_generated
  )

  log_analytics_workspace_sku                          = "PerGB2018"
  log_analytics_workspace_daily_quota_gb               = -1
  log_analytics_workspace_retention_in_days            = local.objective_code == "SEGU" ? 365 : 90
  log_analytics_workspace_local_authentication_enabled = true

  # --- RBAC/Role Definitions ---
  role_definition_resource_substring = "/providers/microsoft.authorization/roledefinitions/"

}
