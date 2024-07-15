locals {
  resource_names = {
    transit_rg_name                   = lower(join("-", [var.cloudspace_id, var.region, var.application_name, var.transit_rg_name]))
    key_vault_name                    = lower(join("-", [var.cloudspace_id, var.region, var.application_name, var.transit_key_vault_name]))
    postgresdb_name                   = lower(join("-", [var.postgres_flexible_server_name, var.application_name]))
    postgresql_dedicated_subnet_name  = lower(join("-", [var.postgres_flexible_server_name, var.application_name, "subnet"]))
    postgresql_private_dns_name       = lower(join("-", [var.postgres_flexible_server_name, var.application_name, "pdz.postgres.database.azure.com"]))
    postgresql_private_dns_v_net_link = lower(join("-", [var.postgres_flexible_server_name, var.application_name, "pdzvnetlink.com"]))
    postgresql_database               = lower(join("-", [var.postgres_flexible_server_name, var.application_name, "database"]))
  }

  tags = {
    Customer           = var.customer
    BusinessUnit       = var.business_unit
    ApplicationName    = var.applicationname
    DataClassification = var.data_classification
    Environment        = var.environment
    OwnerName          = var.owner_name
    Contact            = var.contact
  }
}

# module "resource_group" {
#   source   = "./modules/resource_group"
#   name     = local.resource_names.transit_rg_name
#   location = var.location
#   tags     = merge({ "ResourceName" = format("%s", local.resource_names.transit_rg_name) }, local.tags)
# }

# module "argocd" {
#   source                 = "./modules/argocd"
#   app_client_oidc_id     = var.app_client_oidc_id
#   app_client_oidc_secret = var.app_client_oidc_secret
# }

module "key_vault" {
  source                        = "./modules/key_vault"
  key_vault_name                = local.resource_names.key_vault_name
  key_vault_default_subnet_name = var.key_vault_default_subnet_name
  location                      = var.location
  managed_resource_group        = var.managed_resource_group
  existing_v_net_name           = var.existing_v_net_name
  deployment_resource_group     = var.deployment_resource_group
  tags                          = merge({ "ResourceName" = format("%s", local.resource_names.key_vault_name) }, local.tags)
}

module "postgresql-server" {
  source                           = "./modules/PostgreSQL_module"
  deployment_resource_group        = var.deployment_resource_group
  managed_resource_group           = var.managed_resource_group
  postgres_sql_server_name         = local.resource_names.postgresdb_name
  key_vault                        = local.resource_names.key_vault_name
  existing_v_net_name              = var.existing_v_net_name
  postgresql_dedicated_subnet_name = local.resource_names.postgresql_dedicated_subnet_name
  private_dns_name                 = local.resource_names.postgresql_private_dns_name
  private_dns_v_net_link           = local.resource_names.postgresql_private_dns_v_net_link
  postgres_db_username             = var.postgres_db_username
  database                         = local.resource_names.postgresql_database
  postgres_password_key            = var.postgres_password_key
  postgres_username_key            = var.postgres_username_key
  address_prefixes                 = var.address_prefixes
  tags                             = merge({ "ResourceName" = format("%s", local.resource_names.postgresdb_name) }, local.tags)
  depends_on                       = [module.key_vault]
}

module "acr_module" {
  source                    = "./modules/acr_module"
  acr_name                  = var.acr_name
  deployment_resource_group = var.deployment_resource_group
  managed_resource_group    = var.managed_resource_group
  location                  = var.location
  existing_v_net_name       = var.existing_v_net_name
  acr_sku                   = var.acr_sku
  acr_public_network_access = var.acr_public_network_access
  acr_admin_enabled         = var.acr_admin_enabled
  default_subnet_name       = var.default_subnet_name
  acr_private_dns_name      = var.acr_private_dns_name
  tags                      = merge({ "ResourceName" = format("%s", var.acr_name) }, local.tags)
}

module "Storage-account" {
  source                           = "./modules/Storage-account"
  storage_account_name             = var.storage_account_name
  existing_v_net_name              = var.existing_v_net_name
  customer_managed_key             = var.customer_managed_key
  deployment_resource_group        = var.deployment_resource_group
  share_name                       = var.share_name
  managed_resource_group           = var.managed_resource_group
  location                         = var.location
  key_vault                        = local.resource_names.key_vault_name
  storage_account_private_dns_name = var.storage_account_private_dns_name
  depends_on                       = [module.key_vault]
}
