locals {
  # Map Azure location to region_code for Americas (USA, Canada, etc.)
  location_to_region_code = {
    # USA
    "eastus"              = "EUS"
    "eastus2"             = "EUS2"
    "centralus"           = "CUS"
    "northcentralus"      = "NCUS"
    "southcentralus"      = "SCUS"
    "westus"              = "WUS"
    "westus2"             = "WUS2"
    "westus3"             = "WUS3"
    "southcentralusstage" = "SCUSS"
    # Canada
    "canadacentral" = "CCAN"
    "canadaeast"    = "ECAN"
    # Brazil
    "brazilsouth"     = "BSOU"
    "brazilsoutheast" = "BSE"
    # Mexico
    "mexicocentral" = "MCEN"
    # Chile
    "chilecentral" = "CCEN"
  }


  service_code                 = "LAW"
  service_code_rsg             = "RSG"
  region_code                  = lookup(local.location_to_region_code, var.location, "EUS2")
  application_code             = var.application_code
  objective_code               = var.objective_code
  environment                  = var.environment
  correlative                  = var.correlative
  log_analytics_workspace_name = lower("${local.service_code}${local.region_code}${local.application_code}${local.environment}${local.correlative}")
  resource_group_name          = "${local.service_code_rsg}${local.region_code}${local.application_code}${local.environment}${local.correlative}"
  #name             = "${local.service_code}${local.region_code}${local.application_code}${local.objective_code}${local.environment}${local.correlative}"
  # resource_group_name                                   = "${local.service_code_rg}${local.region_code}${local.application_code}${local.environment}${local.correlative}"
  log_analytics_workspace_sku                           = "PerGB2018"
  log_analytics_workspace_daily_quota_gb                = -1
  log_analytics_workspace_retention_in_days             = local.objective_code == "SEGU" ? 365 : 90
  log_analytics_workspace_local_authentication_disabled = true

  # --- RBAC/Role Definitions ---
  role_definition_resource_substring = "/providers/microsoft.authorization/roledefinitions/"
}
