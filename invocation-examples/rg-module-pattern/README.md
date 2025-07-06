<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.28 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.28.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_law_actual"></a> [law\_actual](#module\_law\_actual) | ../../ | n/a |
| <a name="module_law_for_coordination"></a> [law\_for\_coordination](#module\_law\_for\_coordination) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.alz_compliant](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rg_module_pattern_result"></a> [rg\_module\_pattern\_result](#output\_rg\_module\_pattern\_result) | Shows how RG module coordinates with LAW module |
<!-- END_TF_DOCS -->