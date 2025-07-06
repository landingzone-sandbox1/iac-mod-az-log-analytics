# Log Analytics Workspace Module - Usage Examples

This directory contains three complete examples demonstrating different usage patterns for the Azure Log Analytics Workspace Terraform module.

## 📁 Available Examples

### 1. 🚀 **basic-log-analytics-provisioning**
**Use Case:** Simple, standalone Log Analytics Workspace deployment

**When to Use:**
- You need a basic LAW with minimal configuration
- You want to see all required variables in one place
- You're learning how to use the module

**What it Does:**
- Creates an ALZ-compliant Resource Group manually
- Deploys a Log Analytics Workspace into that RG
- Demonstrates basic RBAC role assignment
- Shows essential configuration options

**Key Features:**
- ✅ Full variable examples with defaults
- ✅ ALZ-compliant naming for both RG and LAW
- ✅ Least-privilege RBAC enforcement
- ✅ Security-first configuration defaults

---

### 2. 🏗️ **rg-module-pattern**
**Use Case:** Coordination between RG module and LAW module

**When to Use:**
- You have a separate RG module that needs to create LAWs
- You need ALZ naming coordination between modules
- You're building a modular infrastructure pattern

**What it Does:**
- Shows how an RG module can query expected ALZ names
- Creates RG with the exact ALZ-compliant name expected by LAW module
- Deploys LAW using the coordinated naming
- Validates that names match correctly

**Key Features:**
- ✅ Module-to-module coordination pattern
- ✅ ALZ naming consistency enforcement
- ✅ Two-step process: name query → RG creation → LAW deployment
- ✅ Validation outputs to confirm coordination

---

### 3. 🔄 **existing-rg**
**Use Case:** Adding LAW to pre-existing Resource Groups

**When to Use:**
- You have existing ALZ-compliant Resource Groups
- You want to add multiple LAWs to the same RG
- You're working with shared infrastructure

**What it Does:**
- Uses existing, ALZ-compliant Resource Groups
- Deploys multiple LAWs with different objectives into same RG
- Shows how to reuse RGs across workspaces
- Demonstrates multi-LAW scenarios

**Key Features:**
- ✅ Multiple LAWs in single RG
- ✅ Different objective codes for different purposes
- ✅ Shared infrastructure pattern
- ✅ ALZ compliance validation

---

## 🎯 **Module Interface Summary**

**Core Principle:** This LAW module **NEVER creates Resource Groups** - it only creates Log Analytics Workspaces.

### Required Inputs
- `location` (string): Azure region (must be supported)
- `resource_group_name` (string): ALZ-compliant RG name (**must exist**)
- `naming` (object): LAW naming parameters
- `log_analytics_config` (object): LAW configuration

### ALZ Naming Conventions

**Resource Group Pattern:**
```
RSG{region_3char}{app_4char}{env_1char}{correlative_2digit}
Example: RSGEU2MBBKD01 (13 characters total)
```

**Log Analytics Workspace Pattern:**
```
law{region_3char}{app_4char}{objective_3-4char}{env_1char}{correlative_2digit}
Example: laweu2mbbksegud01 (lowercase)
```

### Key Validation Rules
- ✅ RG names must follow strict ALZ pattern
- ✅ RG must exist before LAW deployment
- ✅ Only least-privilege RBAC roles allowed
- ✅ Secure defaults for all security settings
- ✅ Environment codes: D/P/C/F only

---

## 🚀 **Quick Start**

1. **Choose your pattern:**
   - New project? → Start with `basic-log-analytics-provisioning`
   - RG module coordination? → Use `rg-module-pattern`
   - Existing RG? → Use `existing-rg`

2. **Copy and modify:**
   ```bash
   cp -r invocation-examples/basic-log-analytics-provisioning my-law-deployment
   cd my-law-deployment
   # Edit example.tf with your values
   terraform init
   terraform plan
   ```

3. **Key variables to customize:**
   - `location`: Your Azure region
   - `resource_group_name`: Your ALZ-compliant RG name
   - `naming.application_code`: Your 4-char app code
   - `naming.objective_code`: Your LAW purpose (e.g., "SEGU", "MONI")
   - `naming.environment`: D/P/C/F
   - `log_analytics_config.tags`: Your tags

---

## ✅ **Validation Status**

All examples have been validated:
- ✅ `terraform validate` passes for all examples
- ✅ ALZ naming compliance enforced
- ✅ Security best practices implemented
- ✅ Module interface consistency confirmed

---

## 📚 **Additional Resources**

- [ALZ Naming Convention Standards](https://github.com/landingzone-sandbox/wiki-landing-zone/wiki/ALZ-+-GEN-IA-Landing-Zone-(MS-English)-(M1)---Resource-Organization-Naming-Convention-Standards)
- [Azure Log Analytics Documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/)
- [Terraform AzureRM Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
