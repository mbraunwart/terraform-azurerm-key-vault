data "azurerm_client_config" "current" {}

locals {
  resource_tags = {
    resourceType  = "Key Vault"
    securityLevel = "High"
    service       = "Security"
  }
  merged_tags = merge(var.tags, local.resource_tags)
  # Add filtering for service principal IDs
  filtered_sp_ids = var.service_principal_ids != null ? [for id in var.service_principal_ids : id if id != null && id != ""] : []
}

resource "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  dynamic "network_acls" {
    for_each = var.network_acls != null && length(var.network_acls) > 0 ? var.network_acls : []
    content {
      bypass                     = network_acls.value.bypass
      default_action             = network_acls.value.default_action
      ip_rules                   = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }
  }
  
  tags = local.merged_tags
}

resource "azurerm_key_vault_access_policy" "current_user" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set"
  ]

  key_permissions = [
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "UnwrapKey",
    "Verify",
    "WrapKey"
  ]

  storage_permissions = [
    "Backup",
    "Delete",
    "DeleteSAS",
    "Get",
    "GetSAS",
    "List",
    "ListSAS",
    "Purge",
    "Recover",
    "RegenerateKey",
    "Restore",
    "Set",
    "SetSAS",
    "Update"
  ]

  certificate_permissions = [
    "Backup",
    "Create",
    "Delete",
    "DeleteIssuers",
    "Get",
    "GetIssuers",
    "Import",
    "List",
    "ListIssuers",
    "ManageContacts",
    "ManageIssuers",
    "Purge",
    "Recover",
    "Restore",
    "SetIssuers",
    "Update"
  ]
}

resource "azurerm_key_vault_access_policy" "secret_user" {
  for_each     = toset(local.filtered_sp_ids)
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = each.value

  secret_permissions = [
    "Get",
    "List",
    "Set"
  ]
}

resource "azurerm_role_assignment" "service" {
  for_each             = toset(local.filtered_sp_ids)
  principal_id         = each.value
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
}
