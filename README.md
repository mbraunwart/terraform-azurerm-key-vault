---
title: "Azure Enterprise Key Vault Module"
author: "Matt Braunwart"
date: "2024-01-24"
tags: ["azure", "security", "key-vault", "secrets", "terraform", "infrastructure"]
summary: "Terraform module for deploying and managing Azure Key Vaults with integrated security features and access controls"
---

<!-- BEGIN_TF_DOCS -->
<!-- TOC -->
- [Azure Enterprise Key Vault Module](#azure-enterprise-key-vault-module)
  - [Purpose](#purpose)
  - [Key Capabilities](#key-capabilities)
  - [Implementation Details](#implementation-details)
  - [Core Features](#core-features)
  - [Best Practices](#best-practices)
  - [Network Integration](#network-integration)
  - [Deployment Examples](#deployment-examples)
    - [Production Scenario](#production-scenario)
  - [Requirements](#requirements)
  - [Providers](#providers)
  - [Resources](#resources)
  - [Required Inputs](#required-inputs)
    - [ key\_vault\_name](#-key_vault_name)
    - [ location](#-location)
    - [ resource\_group\_name](#-resource_group_name)
  - [Optional Inputs](#optional-inputs)
    - [ network\_acls](#-network_acls)
    - [ secrets](#-secrets)
    - [ tags](#-tags)
  - [Outputs](#outputs)
    - [ id](#-id)
    - [ location](#-location-1)
    - [ name](#-name)
    - [ resource\_group\_name](#-resource_group_name-1)
    - [ tenant\_id](#-tenant_id)
    - [ vault\_uri](#-vault_uri)
<!-- /TOC -->

# Azure Enterprise Key Vault Module

## Purpose
The **Azure Enterprise Key Vault Module** offers a unified and secure way to provision and maintain Azure Key Vaults. By leveraging this module, you can store secrets, keys, and certificates in an encrypted and isolated environment while enforcing fine-grained, role-based access controls through Azure Active Directory (Azure AD). With support for both user-assigned and system-assigned managed identities, the module seamlessly integrates service principals for automated secret management and provides configurable network access controls to strengthen security even further.

## Key Capabilities
One of the primary objectives of this module is to streamline the process of safeguarding sensitive information within Azure. It achieves this by enabling you to store and manage secrets, keys, and certificates in a centralized vault. Beyond secure storage, the module implements robust access policies managed via Azure AD, making it straightforward to define granular permissions and role-based access control (RBAC). Additionally, its automated secret management capabilities ensure that your applications and services can retrieve and rotate secrets effortlessly, while optional network restrictions allow you to manage connectivity to the vault through firewalls and private endpoints.

## Implementation Details
Built on top of the standard SKU for Azure Key Vault, this module is engineered to meet enterprise-grade requirements for security and compliance. By supporting both user-assigned and system-assigned managed identities, the module caters to different scenarios—whether you prefer explicit identity assignments or rely on system-managed identities for automation. The goal is to offer a consistent deployment experience that emphasizes simplicity, security, and straightforward integration with other Azure services.

## Core Features
The **Azure Enterprise Key Vault Module** encompasses various features designed to facilitate resource organization, access management, and secret lifecycle control. For instance, it simplifies the creation and management of access policies by integrating directly with Azure AD, removing the need for manual policy definitions. The module also supports service principal authentication, allowing you to automate secret rotation and retrieval without storing credentials in your code. Moreover, each secret maintains version history, enabling you to revert to or audit previous versions when necessary. To help keep your environment tidy, the module enforces a tag-based resource organization strategy, offering a consistent tagging format across all Key Vault resources.

## Best Practices
In alignment with industry standards, the module upholds the principle of least privilege. Access to secrets, keys, and certificates is tightly controlled, granting only the necessary permissions to authorized identities. Secure secret management is further enhanced by leveraging Azure AD authentication, which ensures that credentials are never exposed or stored in plaintext. For organizations needing additional control and compliance, the module’s network isolation capabilities—including firewall rules and private endpoints—add another layer of protection. Meanwhile, resource tagging makes it easier to track and manage costs, ownership, and lifecycle policies across multiple subscriptions. Finally, by enabling monitoring and auditing of vault activities, the module helps you maintain visibility and compliance with corporate and regulatory requirements.

---

## Network Integration
The module supports secure network connectivity through:
- Private endpoint integration for internal network access
- Virtual network service endpoints for controlled access
- Network ACLs for IP-based access control
- Automatic DNS zone integration for private endpoints

## Deployment Examples
### Production Scenario
```hcl
module "prod_key_vault" {
  source              = "../../"
  key_vault_name      = "prod-app-kv"
  resource_group_name = "prod-security-rg"
  location            = "eastus2"
  network_acls = {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = ["10.0.0.0/24"]
  }
}
```

## Requirements

The following requirements are needed by this module:

- <a name="requirement_azurerm"></a> [azurerm](#requirement_azurerm) (~> 4.12.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) (~> 4.12.0)

## Resources

The following resources are used by this module:

- [azurerm_key_vault.kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) (resource)
- [azurerm_key_vault_access_policy.current_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) (resource)
- [azurerm_key_vault_access_policy.secret_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) (resource)
- [azurerm_key_vault_secret.s](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) (resource)
- [azurerm_role_assignment.service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_key_vault_name"></a> [key_vault_name](#input_key_vault_name)

Description: The name of the key vault.

Type: `string`

### <a name="input_location"></a> [location](#input_location)

Description: The location/region where the key vault should be created.

Type: `string`

### <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name)

Description: The name of the resource group in which the key vault should be created.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_network_acls"></a> [network_acls](#input_network_acls)

Description:   (Optional) A list of network ACLs to apply to the Key Vault.

  `default_action` - (Optional) The default action when no rule from `ip_rules` and `virtual_network_subnet_ids` match. Possible values are `Allow` and `Deny`. Defaults to `Allow`.
  `bypass` - (Optional) Specifies which traffic can bypass the network rules. Possible values are `AzureServices` and `None`. Defaults to `AzureServices`.
  `ip_rules` - (Optional) A list of IP rules in CIDR format.
  `virtual_network_subnet_ids` - (Optional) A list of virtual network subnet IDs.

Type:

```hcl
list(object({
    bypass                     = optional(string, "AzureServices")
    default_action             = optional(string, "Allow")
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
  }))
```

Default: `[]`

### <a name="input_secrets"></a> [secrets](#input_secrets)

Description: A map of secrets to store in the Key Vault

Type: `map(string)`

Default: `{}`

### <a name="input_tags"></a> [tags](#input_tags)

Description: A mapping of tags to assign to the resources

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_id"></a> [id](#output_id)

Description: The ID of the Key Vault

### <a name="output_location"></a> [location](#output_location)

Description: The Azure region where the Key Vault exists

### <a name="output_name"></a> [name](#output_name)

Description: The name of the Key Vault

### <a name="output_resource_group_name"></a> [resource_group_name](#output_resource_group_name)

Description: The name of the resource group containing the Key Vault

### <a name="output_tenant_id"></a> [tenant_id](#output_tenant_id)

Description: The Azure AD tenant ID that should be used for authenticating requests to the Key Vault

### <a name="output_vault_uri"></a> [vault_uri](#output_vault_uri)

Description: The URI of the Key Vault
<!-- END_TF_DOCS -->