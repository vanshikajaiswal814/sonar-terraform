data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                     = var.key_vault_name
  resource_group_name      = var.deployment_resource_group
  location                 = var.location
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "standard"
  tags                     = var.tags

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Create", "Rotate", "GetRotationPolicy", "SetRotationPolicy", "Delete", "Recover"
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover"
    ]

    certificate_permissions = [
      "Get",
      "List"
    ]

    storage_permissions = [
      "Get",
      "List",
      "Delete",
    ]
  }

  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = [data.azurerm_subnet.default_subnet.id, data.azurerm_subnet.cfw_default.id]
    ip_rules                   = var.whitelist_ip_ranges
  }
}

resource "azurerm_key_vault_access_policy" "sp_devcloud_cloudspace_p_contributor" {
  key_vault_id   = azurerm_key_vault.kv.id
  tenant_id      = data.azurerm_client_config.current.tenant_id
  object_id      = var.sp_devcloud_object_id
  depends_on     = [ azurerm_key_vault.kv ]

  key_permissions = [
    "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore"
  ]

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
  ]

  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "Purge"]
}

resource "azurerm_key_vault_access_policy" "IDM2BCD_BDC_CloudSpace00167_contributor" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.IDM2BCD_BDC_CloudSpace00167_contributor_object_id
  depends_on   = [azurerm_key_vault.kv]

  key_permissions = [
    "Get", "List", "Create"
  ]

  secret_permissions = [
    "Get", "List", "Delete", "Set"
  ]

  certificate_permissions = [
    "Get", "List", "Create"
  ]
}
