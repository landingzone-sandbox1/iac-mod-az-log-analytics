resource "azurerm_log_analytics_workspace" "this" {
  location                        = var.location
  name                            = local.log_analytics_workspace_name
  resource_group_name             = local.resource_group_name
  allow_resource_only_permissions = var.log_analytics_workspace_allow_resource_only_permissions
  cmk_for_query_forced            = var.log_analytics_workspace_cmk_for_query_forced
  daily_quota_gb                  = local.log_analytics_workspace_daily_quota_gb
  internet_ingestion_enabled      = var.log_analytics_workspace_internet_ingestion_enabled
  internet_query_enabled          = var.log_analytics_workspace_internet_query_enabled
  local_authentication_disabled   = local.log_analytics_workspace_local_authentication_disabled
  retention_in_days               = local.log_analytics_workspace_retention_in_days
  sku                             = local.log_analytics_workspace_sku
  tags                            = var.tags

  dynamic "identity" {
    for_each = var.log_analytics_workspace_identity == null ? [] : [var.log_analytics_workspace_identity]

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
  dynamic "timeouts" {
    for_each = var.log_analytics_workspace_timeouts == null ? [] : [var.log_analytics_workspace_timeouts]

    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      read   = timeouts.value.read
      update = timeouts.value.update
    }
  }
}

resource "azurerm_role_assignment" "log_analytics_workspace" {
  for_each = var.network_and_rbac_settings.role_assignments

  principal_id                           = each.value.principal_id
  scope                                  = azurerm_log_analytics_workspace.this.id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check

}
