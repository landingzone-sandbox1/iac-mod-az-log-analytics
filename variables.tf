variable "location" {
  type        = string
  description = "Required. The Azure region for deployment of this resource."
  nullable    = false

  validation {
    condition     = length(trim(var.location, " ")) > 0
    error_message = "The location must not be empty."
  }

  validation {
    condition = contains([
      "East US", "East US 2", "Central US", "North Central US", "South Central US",
      "West US", "West US 2", "West US 3", "Canada Central", "Canada East",
      "Brazil South", "Brazil Southeast", "Mexico Central", "Chile Central"
    ], var.location)
    error_message = "The location must be one of the supported Azure regions: East US, East US 2, Central US, North Central US, South Central US, West US, West US 2, West US 3, Canada Central, Canada East, Brazil South, Brazil Southeast, Mexico Central, Chile Central."
  }
}

variable "naming" {
  type = object({
    application_code = string
    objective_code   = optional(string, "")
    environment      = string
    correlative      = optional(string, "01")
  })
  description = <<DESCRIPTION
Naming convention parameters for resource naming following ALZ standards.
- `application_code` - 4-character application code, uppercase alphanumeric (e.g., MBBK for Mobile Banking)
- `objective_code` - Optional 3-4 character code conveying meaningful purpose (e.g., core, mgmt)
- `environment` - Environment designation: D (Development), P (Production), C (Contingency), F (Infrastructure)
- `correlative` - Optional correlative ID to differentiate similar resources (defaults to "01")
DESCRIPTION

  validation {
    condition     = can(regex("^[A-Z0-9]{4}$", var.naming.application_code))
    error_message = "application_code must be exactly 4 uppercase alphanumeric characters (A-Z, 0-9) per ALZ naming conventions."
  }

  validation {
    condition     = var.naming.objective_code == "" || can(regex("^[A-Za-z0-9]{3,4}$", var.naming.objective_code))
    error_message = "When provided, objective_code must be 3 or 4 alphanumeric characters (letters or numbers). See: https://github.com/landingzone-sandbox/wiki-landing-zone/wiki/ALZ-+-GEN-IA-Landing-Zone-(MS-English)-(M1)---Resource-Organization-Naming-Convention-Standards"
  }

  validation {
    condition     = can(regex("^[DPCF]$", var.naming.environment))
    error_message = "Environment must be one of: D (Development), P (Production), C (Contingency), F (Infrastructure)."
  }

  validation {
    condition     = can(regex("^[0-9]{2}$", var.naming.correlative))
    error_message = "Correlative must be a two-digit string, e.g., '01', '02', etc."
  }
}

variable "log_analytics_config" {
  type = object({
    # Resource Group configuration
    resource_group_name = optional(string, null)

    # Workspace permissions and security
    allow_resource_only_permissions = optional(bool, false)
    cmk_for_query_forced            = optional(bool, false)
    internet_ingestion_enabled      = optional(bool, false)
    internet_query_enabled          = optional(bool, false)

    # Customer Managed Key configuration
    customer_managed_key = optional(object({
      key_vault_resource_id = string
      key_name              = string
      key_version           = optional(string, null)
      user_assigned_identity = optional(object({
        resource_id = string
      }), null)
    }), null)

    # Managed identity configuration
    identity = optional(object({
      identity_ids = optional(set(string))
      type         = string
    }), null)

    # Timeout configuration
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      read   = optional(string)
      update = optional(string)
    }), null)

    # Resource tags
    tags = optional(map(string), null)

    # RBAC role assignments
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      principal_type                         = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
    })), {})

    # Diagnostic settings configuration
    enable_diagnostic_settings = optional(bool, true)
    diagnostic_settings        = optional(map(any), {})
  })
  description = <<DESCRIPTION
Log Analytics Workspace configuration object containing all workspace settings:

Resource Group:
- `resource_group_name` - (Optional) The name of the ALZ-compliant resource group where the Log Analytics Workspace will be deployed. If not provided, an ALZ-compliant name will be auto-generated from the naming parameters.

Security & Access:
- `allow_resource_only_permissions` - (Optional) Allow users to access data for resources they have permission to view. Defaults to false for security.
- `cmk_for_query_forced` - (Optional) Force Customer Managed Key for query management. Defaults to false for compatibility.
- `internet_ingestion_enabled` - (Optional) Support ingestion over Public Internet. Defaults to false.
- `internet_query_enabled` - (Optional) Support querying over Public Internet. Defaults to false.

Customer Managed Key:
- `customer_managed_key` - (Optional) Customer-managed encryption key configuration with the following properties:
  - `key_vault_resource_id` - The resource ID of the Key Vault where the key is stored
  - `key_name` - The name of the key
  - `key_version` - (Optional) The version of the key. If not specified, the latest version is used
  - `user_assigned_identity` - (Optional) User-assigned identity with resource_id property

Identity & RBAC:
- `identity` - (Optional) Managed identity configuration with type and identity_ids
- `role_assignments` - (Optional) Map of RBAC role assignments (least-privilege enforced)

Diagnostic Settings:
- `enable_diagnostic_settings` - (Optional) Enable diagnostic settings for activity logs. Defaults to true.
- `diagnostic_settings` - (Optional) Map of diagnostic settings configuration.

Operations:
- `timeouts` - (Optional) Terraform operation timeouts
- `tags` - (Optional) Resource tags

See individual validation rules for detailed requirements.
DESCRIPTION

  # Validate resource_group_name if provided (when null, computed ALZ name will be used)
  validation {
    condition = (
      var.log_analytics_config.resource_group_name == null ||
      try(length(trim(var.log_analytics_config.resource_group_name, " ")) > 0, false)
    )
    error_message = "resource_group_name, if provided, must not be empty."
  }

  # Validate Azure resource group naming rules if provided
  validation {
    condition = (
      var.log_analytics_config.resource_group_name == null ||
      try(
        can(regex("^[a-zA-Z0-9._()-]{1,90}$", var.log_analytics_config.resource_group_name)) &&
        !can(regex("\\.$", var.log_analytics_config.resource_group_name)),
        false
      )
    )
    error_message = "resource_group_name, if provided, must follow Azure naming rules: 1-90 characters, alphanumeric plus ._()-, and cannot end with a period."
  }

  # Enforce strict ALZ naming compliance for Resource Groups if provided
  validation {
    condition = (
      var.log_analytics_config.resource_group_name == null ||
      can(regex("^RSG[A-Z0-9]{3}[A-Z0-9]{4}[DPCF][0-9]{2}$", var.log_analytics_config.resource_group_name))
    )
    error_message = "resource_group_name, if provided, must follow ALZ RG naming convention: RSG{region_3char}{app_code_4char}{env_1char}{correlative_2digit} (e.g., RSGEU2MBBKD01). Total length: 13 characters."
  }

  # Validate identity configuration
  validation {
    condition = (
      var.log_analytics_config.identity == null ||
      contains(["SystemAssigned", "UserAssigned"], try(var.log_analytics_config.identity.type, ""))
    )
    error_message = "If identity is set, type must be either 'SystemAssigned' or 'UserAssigned'."
  }

  # Validate identity_ids for UserAssigned type
  validation {
    condition = (
      var.log_analytics_config.identity == null ||
      try(var.log_analytics_config.identity.type, null) != "UserAssigned" ||
      try(var.log_analytics_config.identity.identity_ids, null) != null
    )
    error_message = "When identity type is 'UserAssigned', identity_ids must be provided."
  }

  # Validate timeout format
  validation {
    condition = (
      var.log_analytics_config.timeouts == null ||
      alltrue([
        for k, v in coalesce(var.log_analytics_config.timeouts, {}) :
        v == null || can(regex("^[0-9]+m$", v))
      ])
    )
    error_message = "Timeouts, if set, must be a string ending with 'm' (e.g., '30m')."
  }

  # Validate tags format
  validation {
    condition = (
      var.log_analytics_config.tags == null ||
      alltrue([
        for k, v in coalesce(var.log_analytics_config.tags, {}) :
        can(regex("^[A-Za-z0-9-_]+$", k)) && can(regex("^[A-Za-z0-9-_., ]*$", v))
      ])
    )
    error_message = "Tag keys must be alphanumeric, dash, or underscore. Tag values can include alphanumeric characters, spaces, dashes, underscores, periods, and commas."
  }

  # Validate customer_managed_key configuration
  validation {
    condition = (
      var.log_analytics_config.customer_managed_key == null ||
      (try(var.log_analytics_config.customer_managed_key.key_vault_resource_id, null) != null &&
      try(var.log_analytics_config.customer_managed_key.key_name, null) != null)
    )
    error_message = "If customer_managed_key is set, both key_vault_resource_id and key_name must be provided."
  }

  # Validate role assignment principal types
  validation {
    condition = (
      length(coalesce(var.log_analytics_config.role_assignments, {})) == 0 ||
      alltrue([
        for ra in values(var.log_analytics_config.role_assignments) : (
          contains(["ServicePrincipal", "ManagedIdentity"], ra.principal_type)
        )
      ])
    )
    error_message = "If set, all role assignments must have principal_type set to 'ServicePrincipal' or 'ManagedIdentity'."
  }

  # Enforce least-privilege roles only
  validation {
    condition = (
      length(coalesce(var.log_analytics_config.role_assignments, {})) == 0 ||
      alltrue([
        for ra in values(var.log_analytics_config.role_assignments) : (
          contains([
            # Log Analytics specific roles (read-only for least privilege)
            "Log Analytics Reader",
            # Monitoring roles (read-only and metrics publishing only)
            "Monitoring Reader",
            "Monitoring Metrics Publisher",
            # Security roles (read-only only)
            "Security Reader"
          ], ra.role_definition_id_or_name)
        )
      ])
    )
    error_message = "Only true least-privilege roles are allowed: Log Analytics Reader, Monitoring Reader, Monitoring Metrics Publisher, Security Reader. Administrative roles like Contributors, Admins, Owners are not permitted."
  }

  # Block high-privilege role IDs
  validation {
    condition = (
      length(coalesce(var.log_analytics_config.role_assignments, {})) == 0 ||
      alltrue([
        for ra in values(var.log_analytics_config.role_assignments) : (
          # Block common high-privilege role IDs that users might try to sneak in
          !contains([
            # Owner role ID
            "8e3af657-a8ff-443c-a75c-2fe8c4bcb635",
            # Contributor role ID  
            "b24988ac-6180-42a0-ab88-20f7382dd24c",
            # User Access Administrator role ID
            "18d7d88d-d35e-4fb5-a5c3-7773c20a72d9",
            # Security Admin role ID
            "fb1c8493-542b-48eb-b624-b4c8fea62acd",
            # Log Analytics Contributor role ID (too powerful)
            "92aaf0da-9dab-42b6-94a3-d43ce8d16293",
            # Monitoring Contributor role ID (too powerful)
            "749f88d5-cbae-40b8-bcfc-e573ddc772fa"
          ], ra.role_definition_id_or_name)
        )
      ])
    )
    error_message = "High-privilege role IDs are explicitly blocked. Only use the allowed role names, not role definition IDs."
  }
}