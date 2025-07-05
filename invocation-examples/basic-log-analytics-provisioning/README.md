<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.28 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.28.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azure_log_analytics_example"></a> [azure\_log\_analytics\_example](#module\_azure\_log\_analytics\_example) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.example](https://registry.terraform.io/providers/hashicorp/azurerm/4.28/docs/resources/resource_group) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/4.28/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_code"></a> [application\_code](#input\_application\_code) | 4-character application code, uppercase alphanumeric (e.g., AP01 for Application 01). | `string` | `"AP01"` | no |
| <a name="input_correlative"></a> [correlative](#input\_correlative) | An optional correlative ID to differentiate between similar resources. | `string` | `"01"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment for deployment (e.g., D, P, C). | `string` | `"D"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region for the workspace. | `string` | `"East US 2"` | no |
| <a name="input_objective_code"></a> [objective\_code](#input\_objective\_code) | A 3 to 4 character code conveying a meaningful purpose for the resource (e.g., core, mgmt, segu). | `string` | `"MON"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Optional metadata tags. | `map(string)` | <pre>{<br/>  "Environment": "Development",<br/>  "ManagedBy": "Terraform",<br/>  "Purpose": "Log Analytics Example"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#output\_log\_analytics\_workspace\_id) | Resource ID of the Log Analytics Workspace. |
| <a name="output_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#output\_log\_analytics\_workspace\_name) | Name of the Log Analytics Workspace. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the created resource group. |
<!-- END_TF_DOCS -->