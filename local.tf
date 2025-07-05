locals {
  # Map Azure location to region_code for Americas (USA, Canada, etc.)
  location_to_region_code = {
    "East US"          = "EUS"
    "East US 2"        = "EUS2"
    "Central US"       = "CUS"
    "North Central US" = "NCUS"
    "South Central US" = "SCUS"
    "West US"          = "WUS"
    "West US 2"        = "WUS2"
    "West US 3"        = "WUS3"
    "Canada Central"   = "CCAN"
    "Canada East"      = "ECAN"
    "Brazil South"     = "BSOU"
    "Brazil Southeast" = "BSE"
    "Mexico Central"   = "MCEN"
    "Chile Central"    = "CCEN"

  }

  service_code                 = "LAW"
  service_code_rsg             = "RSG"
  application_code             = var.naming.application_code
  objective_code               = var.naming.objective_code
  environment                  = var.naming.environment
  correlative                  = var.naming.correlative
  region_code                  = lookup(local.location_to_region_code, var.location, "EUS2")
  log_analytics_workspace_name = lower("${local.service_code}${local.region_code}${local.application_code}${local.objective_code}${local.environment}${local.correlative}")
  # tflint-ignore: terraform_unused_declarations
  resource_group_name                                   = upper("${local.service_code_rsg}${local.region_code}${local.application_code}${local.objective_code}${local.environment}${local.correlative}")
  log_analytics_workspace_sku                           = "PerGB2018"
  log_analytics_workspace_daily_quota_gb                = -1
  log_analytics_workspace_retention_in_days             = local.objective_code == "SEGU" ? 365 : 90
  log_analytics_workspace_local_authentication_disabled = true

  # --- RBAC/Role Definitions ---
  role_definition_resource_substring = "/providers/microsoft.authorization/roledefinitions/"

}
