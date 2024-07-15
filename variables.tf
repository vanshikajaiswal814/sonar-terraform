# variable "app_client_oidc_secret" {
#   type        = string
#   description = "Service principal client secret for oidc"
# }

# variable "app_client_oidc_id" {
#   type        = string
#   description = "Service principal client id for oidc"
# }

variable "aks_cluster_name" {
  type        = string
  description = "Cluster name of aks"
}

variable "terraform_server_id" {
  type        = string
  description = "Server id of azure service principal account"
}

variable "location" {
  type        = string
  description = "Name of the cfw Resource group location"
}

#naming conventions
variable "transit_rg_name" {
  type        = string
  description = "Name of the cfw Resource group name"
}

variable "transit_key_vault_name" {
  type        = string
  description = "key vault transit name"
}

variable "cloudspace_id" {
  type        = string
  description = "cfw cloudspace id"
}

variable "region" {
  type        = string
  default     = ""
  description = "ShortName of the cfw Resource group region"
}

variable "application_name" {
  description = "application name with env"
  type        = string
}
###################################################
# TAGs
###################################################

variable "customer" {
  description = "The customer name of the project."
  type        = string
  default     = ""
}

variable "environment" {
  type    = string
  default = ""
}

variable "business_unit" {
  type = string
}

variable "applicationname" {
  type = string
}

variable "applicationname_short" {
  type = string
}

variable "owner_name" {
  type = string
}

variable "data_classification" {
  type = string
}

variable "contact" {
  type = string
}

# Postgres server details
variable "postgres_flexible_server_name" {
  type        = string
  description = "Prefix of the resource name."
}

variable "postgres_version" {
  default     = "16"
  description = "This variable holds the version of PostgreSQL server to be used."
}

# Storage profile
variable "postgresql_storage_profile" {
  type        = map(string)
  description = "This is a list of values pertaining to the storage configuration of the PostgreSQL server."

  default = {
    "storage_in_mb"                = 32768
    "storage_tier"                 = "P20"
    "backup_retention_days"        = 7
    "auto_grow_enabled"            = false
    "geo_redundant_backup_enabled" = false
  }

}

variable "postgresql_sku_name" {
  default     = "B_Standard_B4ms"
  type        = string
  description = "This is the Compute Sku required for PostgreSQL server."
}

# Database details
variable "charset" {
  type        = string
  description = "Database charset"
  default     = "utf8"
}

variable "collation" {
  type        = string
  description = "Database collation"
  default     = "en_US.utf8"
}

variable "postgres_db_username" {
  type        = string
  description = "This is the username that is required to login to the PostgreSQL DB server."
}

variable "postgres_password_key" {
  type        = string
  description = "Secret name for Postgres password"
}
variable "postgres_username_key" {
  type        = string
  description = "Secret name for Postgres username"
}

variable "address_prefixes" {
  description = "List of address prefixes of postgresql subnet"
  type        = list(string)
}


# Infra and services related details

variable "deployment_resource_group" {
  type        = string
  description = "This is the deployed resource group. We have to use existing services (like V-net) from this RG."
}

variable "managed_resource_group" {
  type        = string
  description = "This is the managed resource group. We have to use existing services (like V-net) from this RG."
}
variable "existing_v_net_name" {
  type        = string
  description = "This is the name of the existing V-Net."
}

# keyvault
variable "key_vault_default_subnet_name" {
  type        = string
  description = "keyvault default subnet"
}

# ACR Variables
variable "acr_sku" {
  type        = string
  description = "Type of SKU for ACR."
}

variable "acr_name" {
  type        = string
  description = "Name of the Azure Container Registry"
}

variable "default_subnet_name" {
  type        = string
  description = "Name of an exising Subnet."
}

variable "acr_admin_enabled" {
  type        = bool
  description = "Flag to enable Admin for ACR."
}

variable "acr_public_network_access" {
  type        = bool
  description = "Flag to enable/disable public access to ACR."
}

variable "acr_private_dns_name" {
  type        = string
  description = "This is the private DNS name required for ACR."
}

# Storage account

variable "storage_account_name" {
  type        = string
  description = "name of storage account"
}

variable "share_name" {
  type        = string
  description = "name of the azure file share"
}

variable "customer_managed_key" {
  type        = string
  description = "customer managed key for storage account."
}

variable "storage_account_private_dns_name" {
  type        = string
  description = "This is the private DNS name required for ACR."
}
