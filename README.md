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
| <a name="input_location"></a> [location](#input\_location) | Required. The Azure region for deployment of this resource. | `string` | n/a | yes |
| <a name="input_log_analytics_config"></a> [log\_analytics\_config](#input\_log\_analytics\_config) | Log Analytics Workspace configuration object containing all workspace settings:<br/><br/>Security & Access:<br/>- `allow_resource_only_permissions` - (Optional) Allow users to access data for resources they have permission to view. Defaults to false for security.<br/>- `cmk_for_query_forced` - (Optional) Force Customer Managed Key for query management. Defaults to false for compatibility.<br/>- `internet_ingestion_enabled` - (Optional) Support ingestion over Public Internet. Defaults to false.<br/>- `internet_query_enabled` - (Optional) Support querying over Public Internet. Defaults to false.<br/><br/>Customer Managed Key:<br/>- `customer_managed_key` - (Optional) Customer-managed encryption key configuration with the following properties:<br/>  - `key_vault_resource_id` - The resource ID of the Key Vault where the key is stored<br/>  - `key_name` - The name of the key<br/>  - `key_version` - (Optional) The version of the key. If not specified, the latest version is used<br/>  - `user_assigned_identity` - (Optional) User-assigned identity with resource\_id property<br/><br/>Identity & RBAC:<br/>- `identity` - (Optional) Managed identity configuration with type and identity\_ids<br/>- `role_assignments` - (Optional) Map of RBAC role assignments (least-privilege enforced)<br/><br/>Operations:<br/>- `timeouts` - (Optional) Terraform operation timeouts<br/>- `tags` - (Optional) Resource tags<br/><br/>See individual validation rules for detailed requirements. | <pre>object({<br/>    # Workspace permissions and security<br/>    allow_resource_only_permissions = optional(bool, false)<br/>    cmk_for_query_forced            = optional(bool, false)<br/>    internet_ingestion_enabled      = optional(bool, false)<br/>    internet_query_enabled          = optional(bool, false)<br/><br/>    # Customer Managed Key configuration<br/>    customer_managed_key = optional(object({<br/>      key_vault_resource_id = string<br/>      key_name              = string<br/>      key_version           = optional(string, null)<br/>      user_assigned_identity = optional(object({<br/>        resource_id = string<br/>      }), null)<br/>    }), null)<br/><br/>    # Managed identity configuration<br/>    identity = optional(object({<br/>      identity_ids = optional(set(string))<br/>      type         = string<br/>    }), null)<br/><br/>    # Timeout configuration<br/>    timeouts = optional(object({<br/>      create = optional(string)<br/>      delete = optional(string)<br/>      read   = optional(string)<br/>      update = optional(string)<br/>    }), null)<br/><br/>    # Resource tags<br/>    tags = optional(map(string), null)<br/><br/>    # RBAC role assignments<br/>    role_assignments = optional(map(object({<br/>      role_definition_id_or_name             = string<br/>      principal_id                           = string<br/>      principal_type                         = string<br/>      description                            = optional(string, null)<br/>      skip_service_principal_aad_check       = optional(bool, false)<br/>      condition                              = optional(string, null)<br/>      condition_version                      = optional(string, null)<br/>      delegated_managed_identity_resource_id = optional(string, null)<br/>    })), {})<br/>  })</pre> | `{}` | no |
| <a name="input_naming"></a> [naming](#input\_naming) | Naming convention parameters for resource naming following ALZ standards.<br/>- `application_code` - 4-character application code, uppercase alphanumeric (e.g., MBBK for Mobile Banking)<br/>- `objective_code` - Optional 3-4 character code conveying meaningful purpose (e.g., core, mgmt)<br/>- `environment` - Environment designation: D (Development), P (Production), C (Contingency), F (Infrastructure)<br/>- `correlative` - Optional correlative ID to differentiate similar resources (defaults to "01") | <pre>object({<br/>    application_code = string<br/>    objective_code   = optional(string, "")<br/>    environment      = string<br/>    correlative      = optional(string, "01")<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#output\_log\_analytics\_workspace\_name) | The computed Log Analytics workspace name following ALZ naming conventions |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The computed resource group name following ALZ naming conventions |
| <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id) | This is the full output for the Log Analytics resource ID |
<!-- END_TF_DOCS -->