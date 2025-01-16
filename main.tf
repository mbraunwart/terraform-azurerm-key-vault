data "azurerm_client_config" "current" {}

locals {
  resource_tags = {
    resourceType  = "Key Vault"
    securityLevel = "High"
    service       = "Security"
  }
  merged_tags = merge(var.tags, local.resource_tags)
}

resource "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  dynamic "network_acls" {
    for_each = var.network_acls
    content {
      bypass        = network_acls.value.bypass
      default_action = network_acls.value.default_action
      ip_rules       = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }
  }

  # By default, Key Vault is only accessible via public endpoints unless 
  # you set up firewall or private endpoints
  # For advanced usage:
  # network_acls {
  #   bypass = "AzureServices"
  #   default_action = "Deny"
  #   ip_rules = ["x.x.x.x/32"]
  # }
  tags = local.merged_tags
}

resource "azurerm_key_vault_access_policy" "current_user" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Delete",
    "Get",
    "List",
    "Set"
  ]
}

resource "azurerm_key_vault_access_policy" "secret_user" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.service_identity.principal_id

  secret_permissions = [
    "Get",
    "List",
    "Set"
  ]
}

resource "azurerm_role_assignment" "service" {
  principal_id         = var.service_identity.principal_id
  scope                = azurerm_key_vault.kv
  role_definition_name = "Key Vault Secrets User"
}
