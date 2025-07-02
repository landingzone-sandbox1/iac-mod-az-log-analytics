locals {
  service_code                 = "LAW"
  service_code_rsg             = "RSG"
  region_code                  = var.region_code
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
