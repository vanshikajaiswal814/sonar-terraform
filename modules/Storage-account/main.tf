data "azurerm_client_config" "current" {}

data "azurerm_virtual_network" "cfw" {
  name                = var.existing_v_net_name
  resource_group_name = var.managed_resource_group
}

data "azurerm_subnet" "aks1" {
  name                 = var.aks1_subnet
  virtual_network_name = var.existing_v_net_name
  resource_group_name  = var.managed_resource_group
}

data "azurerm_subnet" "aks2" {
  name                 = var.aks2_subnet
  virtual_network_name = var.existing_v_net_name
  resource_group_name  = var.managed_resource_group
}

data "azurerm_subnet" "default" {
  name                 = var.default_subnet
  virtual_network_name = var.existing_v_net_name
  resource_group_name  = var.managed_resource_group
}

data "azurerm_key_vault" "default" {
  name                = var.key_vault
  resource_group_name = var.deployment_resource_group
}

resource "azurerm_storage_account" "cfw" {

  name                      = var.storage_account_name
  resource_group_name       = var.deployment_resource_group
  location                  = var.location
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  min_tls_version           = var.min_tls_version
  enable_https_traffic_only = var.enable_https_traffic_only

  network_rules {

    default_action             = var.default_action
    virtual_network_subnet_ids = [data.azurerm_subnet.aks1.id, data.azurerm_subnet.aks2.id, data.azurerm_subnet.default.id]
    ip_rules                   = var.whitelist_ip_ranges
    bypass                     = var.bypass

  }
  identity {
    type = var.identity_type
  }
  lifecycle {
    ignore_changes = [customer_managed_key]
  }
}

resource "azurerm_storage_share" "cfw" {
  name                 = var.share_name
  storage_account_name = azurerm_storage_account.cfw.name
  quota                = var.quota
}

# Create Private DNS Zone for Storage account  
resource "azurerm_private_dns_zone" "storage_account_private_dns_zone" {
  name                = var.storage_account_private_dns_name
  resource_group_name = var.deployment_resource_group
}

#Create DNS Zone Virtual Network Link  
resource "azurerm_private_dns_zone_virtual_network_link" "storage_account_dns_zone_vnet_link" {
  name                  = "${var.storage_account_name}-dnslink"
  resource_group_name   = var.deployment_resource_group
  private_dns_zone_name = azurerm_private_dns_zone.storage_account_private_dns_zone.name
  virtual_network_id    = data.azurerm_virtual_network.cfw.id

  depends_on = [azurerm_private_dns_zone.storage_account_private_dns_zone]
}


resource "azurerm_private_endpoint" "cfw" {

  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.deployment_resource_group
  subnet_id           = data.azurerm_subnet.aks1.id
  private_service_connection {
    name                           = var.private_service_connection_name
    private_connection_resource_id = azurerm_storage_account.cfw.id
    is_manual_connection           = var.is_manual_connection
    subresource_names              = var.subresource_names
  }

  private_dns_zone_group {
    name                 = var.storage_account_private_dns_name
    private_dns_zone_ids = [azurerm_private_dns_zone.storage_account_private_dns_zone.id]
  }

}

resource "azurerm_key_vault_access_policy" "customer_managed_key" {

  key_vault_id = data.azurerm_key_vault.default.id   
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_storage_account.cfw.identity[0].principal_id

  key_permissions = ["Get", "List", "Create", "Encrypt", "Decrypt", "UnwrapKey", "WrapKey"]
}

resource "azurerm_storage_account_customer_managed_key" "example" {
  storage_account_id = azurerm_storage_account.cfw.id
  key_vault_id       = data.azurerm_key_vault.default.id
  key_name           = var.customer_managed_key
  depends_on = [ azurerm_key_vault_access_policy.customer_managed_key ]
}
