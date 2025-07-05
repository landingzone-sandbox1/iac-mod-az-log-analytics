variable "location" {
  type        = string
  description = "Required. The Azure region for deployment of this resource."
  nullable    = false

  validation {
    condition     = length(trim(var.location, " ")) > 0
    error_message = "The location must not be empty."
  }

  validation {
    condition     = contains(keys(local.location_to_region_code), var.location)
    error_message = "The location must be one of the supported Azure regions: ${join(", ", keys(local.location_to_region_code))}."
  }
}


variable "application_code" {
  description = "4-character application code, uppercase alphanumeric (e.g., MBBK for Mobile Banking). Must comply with ALZ naming conventions."
  type        = string
  validation {
    condition     = can(regex("^[A-Z0-9]{4}$", var.application_code))
    error_message = "application_code must be exactly 4 uppercase alphanumeric characters (A-Z, 0-9) per ALZ naming conventions."
  }
}

variable "objective_code" {
  description = "A 3 to 4 character code conveying a meaningful purpose for the resource (e.g., core, mgmt)."
  type        = string
  validation {
    condition     = var.objective_code == "" || can(regex("^[A-Za-z0-9]{3,4}$", var.objective_code))
    error_message = "When provided, objective code must be 3 or 4 alphanumeric characters (letters or numbers). See: https://github.com/landingzone-sandbox/wiki-landing-zone/wiki/ALZ-+-GEN-IA-Landing-Zone-(MS-English)-(M1)---Resource-Organization-Naming-Convention-Standards"
  }

}

variable "environment" {
  description = "The environment for deployment (e.g., D, P, C)."
  type        = string
  nullable    = false
}

variable "correlative" {
  description = "An optional correlative ID to differentiate between similar resources."
  type        = string
  default     = "01"
}

variable "resource_group_name" {
  description = "The name of the Azure Resource Group in which the Log Analytics Workspace should exist."
  type        = string

  validation {
    condition     = can(regex("^RSG[A-Za-z0-9]{3,4}[A-Za-z0-9]{4}[A-Za-z0-9]{1}[A-Za-z0-9]{2}$", var.resource_group_name))
    error_message = "The resource_group_name must match the pattern: RSG<region_code(3,4)><application_code(4)><environment(1)><correlative(2)>, e.g., RSGeus2AP01D01"
  }
}

# required AVM interfaces
# remove only if not supported by the resource
# tflint-ignore: terraform_unused_declarations
variable "customer_managed_key" {
  type = object({
    key_vault_resource_id = string
    key_name              = string
    key_version           = optional(string, null)
    user_assigned_identity = optional(object({
      resource_id = string
    }), null)
  })
  default     = null
  description = <<DESCRIPTION
A map describing customer-managed keys to associate with the resource. This includes the following properties:
- `key_vault_resource_id` - The resource ID of the Key Vault where the key is stored.
- `key_name` - The name of the key.
- `key_version` - (Optional) The version of the key. If not specified, the latest version is used.
- `user_assigned_identity` - (Optional) An object representing a user-assigned identity with the following properties:
  - `resource_id` - The resource ID of the user-assigned identity.
DESCRIPTION  
}

variable "log_analytics_workspace_allow_resource_only_permissions" {
  type        = bool
  default     = false
  description = <<DESC
(Optional) Specifies if the Log Analytics Workspace allows users to access data associated with resources they have permission to view, without permission to the workspace. 
Defaults to `false` for security. Set to `true` only if required for your scenario.
DESC
  nullable    = false
  validation {
    condition     = var.log_analytics_workspace_allow_resource_only_permissions == true || var.log_analytics_workspace_allow_resource_only_permissions == false
    error_message = "Value must be true or false. Default is false for security."
  }
}

variable "log_analytics_workspace_cmk_for_query_forced" {
  type        = bool
  default     = false
  description = <<DESC
(Optional) If set to true, forces Customer Managed Key (CMK) for query management in the Log Analytics Workspace.
Defaults to false for compatibility and to avoid accidental access issues. Set to true only if your compliance or security policy requires it and you have configured a CMK.
DESC
  nullable    = false
  validation {
    condition     = var.log_analytics_workspace_cmk_for_query_forced == true || var.log_analytics_workspace_cmk_for_query_forced == false
    error_message = "Value must be true or false. Default is false for safety and compatibility."
  }
}

# variable "log_analytics_workspace_daily_quota_gb" {
#   type        = number
#   default     = -1
#   description = "(Optional) The workspace daily quota for ingestion in GB. Defaults to -1 (unlimited) if omitted."
# }

variable "log_analytics_workspace_identity" {
  type = object({
    identity_ids = optional(set(string))
    type         = string
  })
  default     = null
  description = <<-EOT
 - `identity_ids` - (Optional) Specifies a list of user managed identity ids to be assigned. Required if `type` is `UserAssigned`.
 - `type` - (Required) Specifies the identity type of the Log Analytics Workspace. Possible values are `SystemAssigned` (where Azure will generate a Service Principal for you) and `UserAssigned` where you can specify the Service Principal IDs in the `identity_ids` field.
EOT
}

variable "log_analytics_workspace_internet_ingestion_enabled" {
  type        = bool
  default     = false
  description = "(Required) Should the Log Analytics Workspace support ingestion over the Public Internet? Defaults to `False`."
}

variable "log_analytics_workspace_internet_query_enabled" {
  type        = bool
  default     = false
  description = "(Required) Should the Log Analytics Workspace support querying over the Public Internet? Defaults to `False`."
}


# variable "log_analytics_workspace_retention_in_days" {
#   type        = number
#   default     = 90
#   description = "(Optional) The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730. all analytics logs, with segu nomenclature set retention to 365 days:"
#   validation {
#     condition     = var.log_analytics_workspace_retention_in_days == 7 || (var.log_analytics_workspace_retention_in_days >= 30 && var.log_analytics_workspace_retention_in_days <= 730)
#     error_message = "Retention must be 7, or between 30 and 730."
#   }
# }

variable "log_analytics_workspace_timeouts" {
  type = object({
    create = optional(string)
    delete = optional(string)
    read   = optional(string)
    update = optional(string)
  })
  default     = null
  description = <<DESCRIPTION
 - `create` - (Defaults to 30 minutes) Used when creating the Log Analytics Workspace.
 - `delete` - (Defaults to 30 minutes) Used when deleting the Log Analytics Workspace.
 - `read` - (Defaults to 5 minutes) Used when retrieving the Log Analytics Workspace.
 - `update` - (Defaults to 30 minutes) Used when updating the Log Analytics Workspace.
DESCRIPTION
}
variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}


variable "role_assignments" {
  description = <<EOT
      role_assignments: Map of RBAC role assignments (see below for structure).
    Each role assignment value must specify:
      - role_definition_id_or_name: The ID or name of the role definition to assign.
      - principal_id: The object ID of the principal (user, group, or service principal).
      - principal_type: Must be either "ServicePrincipal" or "ManagedIdentity".
      Optional fields:
        - description
        - skip_service_principal_aad_check
        - condition
        - condition_version
        - delegated_managed_identity_resource_id
  EOT
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    principal_type                         = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
  }))
  default = {}

  validation {
    condition = (
      length(coalesce(var.role_assignments, {})) == 0 ||
      alltrue([
        for ra in values(var.role_assignments) : (
          contains(["ServicePrincipal", "ManagedIdentity"], ra.principal_type)
        )
      ])
    )
    error_message = "If set, all role assignments must have principal_type set to 'ServicePrincipal' or 'ManagedIdentity'."
  }
}


# Variables to be configured in furture releases of this module.
# variable "monitor_private_link_scope" {
#   type = map(object({
#     name        = optional(string)
#     resource_id = string
#   }))
#   default     = {}
#   description = <<DESCRIPTION

#   DESCRIPTION
#   nullable    = false
# }

# variable "monitor_private_link_scoped_resource" {
#   type = map(object({
#     name        = optional(string)
#     resource_id = string
#   }))
#   default     = {}
#   description = <<DESCRIPTION
#  - `name` - Defaults to the name of the Log Analytics Workspace.
#  - `resource_id` - Resource ID of an existing Monitor Private Link Scope to connect to.
# DESCRIPTION
# }

# variable "monitor_private_link_scoped_service_name" {
#   type        = string
#   default     = null
#   description = "The name of the service to connect to the Monitor Private Link Scope."
# }

# variable "private_endpoints" {
#   type = map(object({
#     name = optional(string, null)
#     role_assignments = optional(map(object({
#       role_definition_id_or_name             = string
#       principal_id                           = string
#       description                            = optional(string, null)
#       skip_service_principal_aad_check       = optional(bool, false)
#       condition                              = optional(string, null)
#       condition_version                      = optional(string, null)
#       delegated_managed_identity_resource_id = optional(string, null)
#       principal_type                         = optional(string, null)
#     })), {})
#     lock = optional(object({
#       kind = string
#       name = optional(string, null)
#     }), null)
#     tags                                    = optional(map(string), null)
#     subnet_resource_id                      = string
#     private_dns_zone_group_name             = optional(string, "default")
#     private_dns_zone_resource_ids           = optional(set(string), [])
#     application_security_group_associations = optional(map(string), {})
#     private_service_connection_name         = optional(string, null)
#     network_interface_name                  = optional(string, null)
#     location                                = optional(string, null)
#     resource_group_name                     = optional(string, null)
#     ip_configurations = optional(map(object({
#       name               = string
#       private_ip_address = string
#     })), {})
#   }))
#   default     = {}
#   description = <<DESCRIPTION
#   A map of private endpoints to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

#   - `name` - (Optional) The name of the private endpoint. One will be generated if not set.
#   - `role_assignments` - (Optional) A map of role assignments to create on the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time. See `var.role_assignments` for more information.
#   - `lock` - (Optional) The lock level to apply to the private endpoint. Default is `None`. Possible values are `None`, `CanNotDelete`, and `ReadOnly`.
#   - `tags` - (Optional) A mapping of tags to assign to the private endpoint.
#   - `subnet_resource_id` - The resource ID of the subnet to deploy the private endpoint in.
#   - `private_dns_zone_group_name` - (Optional) The name of the private DNS zone group. One will be generated if not set.
#   - `private_dns_zone_resource_ids` - (Optional) A set of resource IDs of private DNS zones to associate with the private endpoint. If not set, no zone groups will be created and the private endpoint will not be associated with any private DNS zones. DNS records must be managed external to this module.
#   - `application_security_group_resource_ids` - (Optional) A map of resource IDs of application security groups to associate with the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
#   - `private_service_connection_name` - (Optional) The name of the private service connection. One will be generated if not set.
#   - `network_interface_name` - (Optional) The name of the network interface. One will be generated if not set.
#   - `location` - (Optional) The Azure location where the resources will be deployed. Defaults to the location of the resource group.
#   - `resource_group_name` - (Optional) The resource group where the resources will be deployed. Defaults to the resource group of the Key Vault.
#   - `ip_configurations` - (Optional) A map of IP configurations to create on the private endpoint. If not specified the platform will create one. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
#     - `name` - The name of the IP configuration.
#     - `private_ip_address` - The private IP address of the IP configuration.
#   DESCRIPTION
#   nullable    = false
# }

# variable "private_endpoints_manage_dns_zone_group" {
#   type        = bool
#   default     = true
#   description = "Whether to manage private DNS zone groups with this module. If set to false, you must manage private DNS zone groups externally, e.g. using Azure Policy."
#   nullable    = false
# }

# variable "role_assignments" {
#   type = map(object({
#     role_definition_id_or_name             = string
#     principal_id                           = string
#     description                            = optional(string, null)
#     skip_service_principal_aad_check       = optional(bool, false)
#     condition                              = optional(string, null)
#     condition_version                      = optional(string, null)
#     delegated_managed_identity_resource_id = optional(string, null)
#     principal_type                         = optional(string, null)
#   }))
#   default     = {}
#   description = <<DESCRIPTION
#   A map of role assignments to create on the <RESOURCE>. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

#   - `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
#   - `principal_id` - The ID of the principal to assign the role to.
#   - `description` - (Optional) The description of the role assignment.
#   - `skip_service_principal_aad_check` - (Optional) If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
#   - `condition` - (Optional) The condition which will be used to scope the role assignment.
#   - `condition_version` - (Optional) The version of the condition syntax. Leave as `null` if you are not using a condition, if you are then valid values are '2.0'.
#   - `delegated_managed_identity_resource_id` - (Optional) The delegated Azure Resource Id which contains a Managed Identity. Changing this forces a new resource to be created. This field is only used in cross-tenant scenario.
#   - `principal_type` - (Optional) The type of the `principal_id`. Possible values are `User`, `Group` and `ServicePrincipal`. It is necessary to explicitly set this attribute when creating role assignments if the principal creating the assignment is constrained by ABAC rules that filters on the PrincipalType attribute.

#   > Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
#   DESCRIPTION
#   nullable    = false
# }
# 
# variable "diagnostic_settings" {
#   type = map(object({
#     name                                     = optional(string, null)
#     log_categories                           = optional(set(string), [])
#     log_groups                               = optional(set(string), ["allLogs"])
#     metric_categories                        = optional(set(string), ["AllMetrics"])
#     log_analytics_destination_type           = optional(string, "Dedicated")
#     workspace_resource_id                    = optional(string, null)
#     storage_account_resource_id              = optional(string, null)
#     event_hub_authorization_rule_resource_id = optional(string, null)
#     event_hub_name                           = optional(string, null)
#     marketplace_partner_resource_id          = optional(string, null)
#   }))
#   default     = {}
#   description = <<DESCRIPTION
#   A map of diagnostic settings to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

#   - `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
#   - `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
#   - `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
#   - `metric_categories` - (Optional) A set of metric categories to send to the log analytics workspace. Defaults to `["AllMetrics"]`.
#   - `log_analytics_destination_type` - (Optional) The destination type for the diagnostic setting. Possible values are `Dedicated` and `AzureDiagnostics`. Defaults to `Dedicated`.
#   - `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to.
#   - `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to.
#   - `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to.
#   - `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected.
#   - `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs.
#   DESCRIPTION
#   nullable    = false

#   validation {
#     condition     = alltrue([for _, v in var.diagnostic_settings : contains(["Dedicated", "AzureDiagnostics"], v.log_analytics_destination_type)])
#     error_message = "Log analytics destination type must be one of: 'Dedicated', 'AzureDiagnostics'."
#   }
#   validation {
#     condition = alltrue(
#       [
#         for _, v in var.diagnostic_settings :
#         v.workspace_resource_id != null || v.storage_account_resource_id != null || v.event_hub_authorization_rule_resource_id != null || v.marketplace_partner_resource_id != null
#       ]
#     )
#     error_message = "At least one of `workspace_resource_id`, `storage_account_resource_id`, `marketplace_partner_resource_id`, or `event_hub_authorization_rule_resource_id`, must be set."
#   }
# }

# variable "lock" {
#   type = object({
#     kind = string
#     name = optional(string, null)
#   })
#   default     = null
#   description = <<DESCRIPTION
# Controls the Resource Lock configuration for this resource. The following properties can be specified:

# - `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
# - `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.
# DESCRIPTION

#   validation {
#     condition     = var.lock != null ? contains(["CanNotDelete", "ReadOnly"], var.lock.kind) : true
#     error_message = "The lock level must be one of: 'None', 'CanNotDelete', or 'ReadOnly'."
#   }
# }
