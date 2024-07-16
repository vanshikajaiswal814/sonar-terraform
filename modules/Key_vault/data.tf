# fetching existing virtual network
data "azurerm_virtual_network" "default" {
  name                = var.existing_v_net_name
  resource_group_name = var.managed_resource_group
}

data "azurerm_subnet" "default_subnet" {
  name                 = var.key_vault_default_subnet_name # Name of the existing Subnet
  virtual_network_name = data.azurerm_virtual_network.default.name
  resource_group_name  = data.azurerm_virtual_network.default.resource_group_name
}

data "azurerm_subnet" "cfw_default" {
  name                 = var.default_subnet
  virtual_network_name = data.azurerm_virtual_network.default.name
  resource_group_name  = data.azurerm_virtual_network.default.resource_group_name
}
