# -------------------------- Data block starts here -------------------------------##

# fetching existing virtual network
data "azurerm_virtual_network" "default" {
  name                = var.existing_v_net_name
  resource_group_name = var.managed_resource_group
}

data "azurerm_subnet" "default" {
  name                 = var.default_subnet_name
  resource_group_name  = var.managed_resource_group
  virtual_network_name = data.azurerm_virtual_network.default.name
}

# -------------------------- Data block ends here -------------------------------##

locals {
  whitelist_ip_range = distinct(var.whitelist_ip_ranges)
}

resource "azurerm_container_registry" "acr" {
  name                          = var.acr_name
  resource_group_name           = var.deployment_resource_group
  location                      = var.location
  sku                           = var.acr_sku
  admin_enabled                 = var.acr_admin_enabled
  public_network_access_enabled = var.acr_public_network_access
  tags                          = var.tags

  dynamic "network_rule_set" {
    for_each = var.acr_sku == "Premium" ? [1] : []
    content {
      default_action = "Deny"

      ip_rule = [
        for ip_range in local.whitelist_ip_range : {
          action   = "Allow"
          ip_range = ip_range
        }
      ]
    }
  }

}


# Create Private DNS Zone for ACR  
resource "azurerm_private_dns_zone" "acr_private_dns_zone" {
  name                = var.acr_private_dns_name
  resource_group_name = var.deployment_resource_group
}

#Create DNS Zone Virtual Network Link  
resource "azurerm_private_dns_zone_virtual_network_link" "acr_dns_zone_vnet_link" {
  name                  = "${var.acr_name}-dnslink"
  resource_group_name   = var.deployment_resource_group
  private_dns_zone_name = azurerm_private_dns_zone.acr_private_dns_zone.name
  virtual_network_id    = data.azurerm_virtual_network.default.id

  depends_on = [azurerm_private_dns_zone.acr_private_dns_zone]
}


resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "${var.acr_name}-private-endpoint"
  location            = var.location
  resource_group_name = var.deployment_resource_group
  subnet_id           = data.azurerm_subnet.default.id

  private_service_connection {
    name                           = "${var.acr_name}-privateserviceconnection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_container_registry.acr.id
    subresource_names              = ["registry"]
  }

  private_dns_zone_group {
    name                 = var.acr_private_dns_name
    private_dns_zone_ids = [azurerm_private_dns_zone.acr_private_dns_zone.id]
  }

  depends_on = [azurerm_container_registry.acr,azurerm_private_dns_zone.acr_private_dns_zone]
}
