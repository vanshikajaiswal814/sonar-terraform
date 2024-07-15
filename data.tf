data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  resource_group_name = var.managed_resource_group
}
