# -------------------------- Data block starts here -------------------------------##

# fetching existing virtual network

data "azurerm_virtual_network" "default" {
  name                = var.existing_v_net_name
  resource_group_name = var.managed_resource_group
}

data "azurerm_key_vault" "default" {
  name                = var.key_vault
  resource_group_name = var.deployment_resource_group
}

data "azurerm_client_config" "current" {}

# -------------------------- Data block ends here -------------------------------##


# -------------------------- Resource block starts here -------------------------------##

# Create a random password generator
resource "random_password" "pass" {
  length  = 20
  special = false
}

resource "azurerm_key_vault_secret" "admin_username" {
  name         = var.postgres_username_key
  key_vault_id = data.azurerm_key_vault.default.id
  value        = var.postgres_db_username
}

resource "azurerm_key_vault_secret" "admin_password" {
  name         = var.postgres_password_key
  key_vault_id = data.azurerm_key_vault.default.id
  value        = random_password.pass.result
  depends_on   = [ random_password.pass ]
}

# Creating a dedicated subnet for postgres flexible server
resource "azurerm_subnet" "default" {
  name                 = var.postgresql_dedicated_subnet_name
  virtual_network_name = data.azurerm_virtual_network.default.name
  resource_group_name  = var.managed_resource_group
  address_prefixes     = var.address_prefixes
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "fs"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}


resource "azurerm_private_dns_zone" "default" {
  name                = var.private_dns_name
  resource_group_name = var.deployment_resource_group

}

resource "azurerm_private_dns_zone_virtual_network_link" "default" {
  name                  = var.private_dns_v_net_link
  private_dns_zone_name = azurerm_private_dns_zone.default.name
  virtual_network_id    = data.azurerm_virtual_network.default.id
  resource_group_name   = var.deployment_resource_group
}


# Create Azure postgres flexible server database
resource "azurerm_postgresql_flexible_server" "default" {
  name                = var.postgres_sql_server_name
  resource_group_name = var.deployment_resource_group
  location            = var.location
  version             = var.postgres_version

  delegated_subnet_id           = azurerm_subnet.default.id
  private_dns_zone_id           = azurerm_private_dns_zone.default.id
  # public_network_access_enabled = false

  administrator_login          = azurerm_key_vault_secret.admin_username.value
  administrator_password       = azurerm_key_vault_secret.admin_password.value
  zone                         = "2"
  sku_name                     = var.postgresql_sku_name
  storage_mb                   = var.postgresql_storage_profile.storage_in_mb
  storage_tier                 = var.postgresql_storage_profile.storage_tier
  backup_retention_days        = var.postgresql_storage_profile.backup_retention_days
  auto_grow_enabled            = var.postgresql_storage_profile.auto_grow_enabled
  geo_redundant_backup_enabled = var.postgresql_storage_profile.geo_redundant_backup_enabled
  tags                         = var.tags
  depends_on = [azurerm_private_dns_zone.default, azurerm_private_dns_zone_virtual_network_link.default, azurerm_subnet.default, azurerm_key_vault_secret.admin_username, azurerm_key_vault_secret.admin_password]
}

# Configure PostgreSQL extensions  
resource "azurerm_postgresql_flexible_server_configuration" "postgresql_extensions" {
  name       = "azure.extensions"
  server_id  = azurerm_postgresql_flexible_server.default.id
  value      = "PG_CRON,PG_TRGM,PG_STAT_STATEMENTS"
  depends_on = [azurerm_postgresql_flexible_server.default]
}

resource "azurerm_postgresql_flexible_server_database" "default" {
  name       = var.database 
  server_id  = azurerm_postgresql_flexible_server.default.id
  collation  = var.collation 
  charset    = var.charset   
  
  depends_on = [azurerm_postgresql_flexible_server.default]

}
