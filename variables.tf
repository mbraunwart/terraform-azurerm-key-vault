variable "resource_group_name" {
  description = "The name of the resource group in which the key vault should be created."
  type        = string
}

variable "location" {
  description = "The location/region where the key vault should be created."
  type        = string
}

variable "key_vault_name" {
  description = "The name of the key vault."
  type        = string
}

variable "secrets" {
  type        = map(string)
  default     = {}
  description = "A map of secrets to store in the Key Vault"
}

variable "network_acls" {
  type = list(object({
    bypass                     = optional(string, "AzureServices")
    default_action             = optional(string, "Allow")
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
  }))
  description = <<EOF
  (Optional) A list of network ACLs to apply to the Key Vault.

  `default_action` - (Optional) The default action when no rule from `ip_rules` and `virtual_network_subnet_ids` match. Possible values are `Allow` and `Deny`. Defaults to `Allow`.
  `bypass` - (Optional) Specifies which traffic can bypass the network rules. Possible values are `AzureServices` and `None`. Defaults to `AzureServices`.
  `ip_rules` - (Optional) A list of IP rules in CIDR format.
  `virtual_network_subnet_ids` - (Optional) A list of virtual network subnet IDs.
  EOF

  default = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
