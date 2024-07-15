terraform {
  backend "azurerm" {
    resource_group_name  = var.AZURE_TF_STATE_RESOURCE_GROUP_NAME
    storage_account_name = var.AZURE_TF_STATE_STORAGE_ACCOUNT_NAME
    container_name       = var.AZURE_TF_STATE_STORAGE_CONTAINER_NAME
    key                  = var.AZURE_TF_STATE_STORAGE_CONTAINER_KEY
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.103.0"
    }
  }
  required_version = ">= 0.14"
}
