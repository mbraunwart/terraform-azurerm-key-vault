resource "azurerm_key_vault_secret" "s" {
  for_each     = var.secrets
  key_vault_id = azurerm_key_vault.kv.id
  name         = replace(each.key, "_", "-")
  value        = each.value

  depends_on = [ azurerm_role_assignment.current_client ]
}
