## This file contains all the variables declared in variables.tf that are not to be stored on github.

# Relevant resource groups
managed_resource_group    = "cs00167-we-rg"
location                  = "West Europe"
deployment_resource_group = "cs00167-we-cfw02-rg"

# Existing V-Net
existing_v_net_name = "cs00167-we-vnet"

# Naming conventions
cloudspace_id                 = "cs00167"
region                        = "we"
application_name              = "cfw02"
transit_rg_name               = "rg"
transit_key_vault_name        = "kvt"
postgres_flexible_server_name = "postgresql-server"

# Postgresql flexible server
# admin credentials
postgres_db_username = "Admin_Cfw02"

# address prefix for pgsql subnet 
address_prefixes = ["10.7.76.0/24"]

# Secret Names
postgres_password_key = "postgresql-server-password"
postgres_username_key = "postgresql-server-username"

# ArgoCD
aks_cluster_name           = "cs00167-we-02-aks"

# keyvault
key_vault_default_subnet_name = "zbdcakssubnet02"

# SKU name for ACR
acr_sku                   = "Premium"
acr_name                  = "acrcfw02"
acr_admin_enabled         = true
acr_public_network_access = true
acr_private_dns_name      = "privatelink.azurecr.io"
default_subnet_name       = "DefaultSubnet"

# storage account 

storage_account_name = "stcfw02"
share_name           = "cfw-fileshare02"
storage_account_private_dns_name = "privatelink.file.core.windows.net"
customer_managed_key = "stcfw02storagekey"

#tags
customer              = "test"
applicationname_short = "test"
business_unit         = "test"
applicationname       = "test"
data_classification   = "test"
environment           = "test"
owner_name            = "test"
contact               = "test"

