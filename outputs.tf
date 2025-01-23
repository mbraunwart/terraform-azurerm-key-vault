output "id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.kv.id
}

output "name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.kv.name
}

output "vault_uri" {
  description = "The URI of the Key Vault"
  value       = azurerm_key_vault.kv.vault_uri
}

output "resource_group_name" {
  description = "The name of the resource group containing the Key Vault"
  value       = azurerm_key_vault.kv.resource_group_name
}

output "location" {
  description = "The Azure region where the Key Vault exists"
  value       = azurerm_key_vault.kv.location
}

output "tenant_id" {
  description = "The Azure AD tenant ID that should be used for authenticating requests to the Key Vault"
  value       = azurerm_key_vault.kv.tenant_id
}

output "secret_info" {
  description = "The IDs of the secrets in the Key Vault"
  value = { for secret in azurerm_key_vault_secret.s : secret.name => {
    name = secret.name
    id   = secret.id
  } }
}
