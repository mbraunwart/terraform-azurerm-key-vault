resource "azurerm_key_vault_secret" "s" {
  for_each     = var.secrets
  key_vault_id = azurerm_key_vault.kv.id
  name         = each.key
  value        = each.value
}
