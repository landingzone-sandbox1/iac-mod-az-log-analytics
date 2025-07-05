<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.28 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.28 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.28/docs/resources/log_analytics_workspace) | resource |
| [azurerm_role_assignment.log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/4.28/docs/resources/role_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_code"></a> [application\_code](#input\_application\_code) | 4-character application code, uppercase alphanumeric (e.g., MBBK for Mobile Banking). Must comply with ALZ naming conventions. | `string` | n/a | yes |
| <a name="input_correlative"></a> [correlative](#input\_correlative) | An optional correlative ID to differentiate between similar resources. | `string` | `"01"` | no |
| <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key) | A map describing customer-managed keys to associate with the resource. This includes the following properties:<br/>- `key_vault_resource_id` - The resource ID of the Key Vault where the key is stored.<br/>- `key_name` - The name of the key.<br/>- `key_version` - (Optional) The version of the key. If not specified, the latest version is used.<br/>- `user_assigned_identity` - (Optional) An object representing a user-assigned identity with the following properties:<br/>  - `resource_id` - The resource ID of the user-assigned identity. | <pre>object({<br/>    key_vault_resource_id = string<br/>    key_name              = string<br/>    key_version           = optional(string, null)<br/>    user_assigned_identity = optional(object({<br/>      resource_id = string<br/>    }), null)<br/>  })</pre> | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment for deployment (e.g., D, P, C). | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Required. The Azure region for deployment of this resource. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_allow_resource_only_permissions"></a> [log\_analytics\_workspace\_allow\_resource\_only\_permissions](#input\_log\_analytics\_workspace\_allow\_resource\_only\_permissions) | (Optional) Specifies if the Log Analytics Workspace allows users to access data associated with resources they have permission to view, without permission to the workspace. <br/>Defaults to `false` for security. Set to `true` only if required for your scenario. | `bool` | `false` | no |
| <a name="input_log_analytics_workspace_cmk_for_query_forced"></a> [log\_analytics\_workspace\_cmk\_for\_query\_forced](#input\_log\_analytics\_workspace\_cmk\_for\_query\_forced) | (Optional) If set to true, forces Customer Managed Key (CMK) for query management in the Log Analytics Workspace.<br/>Defaults to false for compatibility and to avoid accidental access issues. Set to true only if your compliance or security policy requires it and you have configured a CMK. | `bool` | `false` | no |
| <a name="input_log_analytics_workspace_identity"></a> [log\_analytics\_workspace\_identity](#input\_log\_analytics\_workspace\_identity) | - `identity_ids` - (Optional) Specifies a list of user managed identity ids to be assigned. Required if `type` is `UserAssigned`.<br/>- `type` - (Required) Specifies the identity type of the Log Analytics Workspace. Possible values are `SystemAssigned` (where Azure will generate a Service Principal for you) and `UserAssigned` where you can specify the Service Principal IDs in the `identity_ids` field. | <pre>object({<br/>    identity_ids = optional(set(string))<br/>    type         = string<br/>  })</pre> | `null` | no |
| <a name="input_log_analytics_workspace_internet_ingestion_enabled"></a> [log\_analytics\_workspace\_internet\_ingestion\_enabled](#input\_log\_analytics\_workspace\_internet\_ingestion\_enabled) | (Required) Should the Log Analytics Workspace support ingestion over the Public Internet? Defaults to `False`. | `bool` | `false` | no |
| <a name="input_log_analytics_workspace_internet_query_enabled"></a> [log\_analytics\_workspace\_internet\_query\_enabled](#input\_log\_analytics\_workspace\_internet\_query\_enabled) | (Required) Should the Log Analytics Workspace support querying over the Public Internet? Defaults to `False`. | `bool` | `false` | no |
| <a name="input_log_analytics_workspace_timeouts"></a> [log\_analytics\_workspace\_timeouts](#input\_log\_analytics\_workspace\_timeouts) | - `create` - (Defaults to 30 minutes) Used when creating the Log Analytics Workspace.<br/> - `delete` - (Defaults to 30 minutes) Used when deleting the Log Analytics Workspace.<br/> - `read` - (Defaults to 5 minutes) Used when retrieving the Log Analytics Workspace.<br/> - `update` - (Defaults to 30 minutes) Used when updating the Log Analytics Workspace. | <pre>object({<br/>    create = optional(string)<br/>    delete = optional(string)<br/>    read   = optional(string)<br/>    update = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_objective_code"></a> [objective\_code](#input\_objective\_code) | A 3 to 4 character code conveying a meaningful purpose for the resource (e.g., core, mgmt). | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Azure Resource Group in which the Log Analytics Workspace should exist. | `string` | n/a | yes |
| <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments) | role\_assignments: Map of RBAC role assignments (see below for structure).<br/>    Each role assignment value must specify:<br/>      - role\_definition\_id\_or\_name: The ID or name of the role definition to assign.<br/>      - principal\_id: The object ID of the principal (user, group, or service principal).<br/>      - principal\_type: Must be either "ServicePrincipal" or "ManagedIdentity".<br/>      Optional fields:<br/>        - description<br/>        - skip\_service\_principal\_aad\_check<br/>        - condition<br/>        - condition\_version<br/>        - delegated\_managed\_identity\_resource\_id | <pre>map(object({<br/>    role_definition_id_or_name             = string<br/>    principal_id                           = string<br/>    principal_type                         = string<br/>    description                            = optional(string, null)<br/>    skip_service_principal_aad_check       = optional(bool, false)<br/>    condition                              = optional(string, null)<br/>    condition_version                      = optional(string, null)<br/>    delegated_managed_identity_resource_id = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Tags of the resource. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#output\_log\_analytics\_workspace\_name) | n/a |
| <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id) | This is the full output for the Log Analytics resource ID |
<!-- END_TF_DOCS -->