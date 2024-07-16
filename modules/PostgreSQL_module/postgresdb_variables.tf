# Postgres server details
variable "postgres_sql_server_name" {
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

variable "location" {
  type        = string
  description = "The location of the The resource group."
  default     = "West Europe"
}

variable "postgresql_sku_name" {
  default     = "B_Standard_B4ms"
  type        = string
  description = "This is the Compute Sku required for PostgreSQL server."
}

# Database details
variable "database" {
  type        = string
  description = "Postgresql database names"
}

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

variable "key_vault" {
  type        = string
  description = "Contains name of the keyvault to be used for secret creation."
}

variable "postgres_db_username" {
  type = string
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
  description = "List of address prefixes"
  type        = list(string)
}

# Infra and services related details
variable "deployment_resource_group" {
  type        = string
  description = "This is the customer resource group. Service should be deployed here."
}
variable "managed_resource_group" {
  type        = string
  description = "This is the managed resource group. We have to use existing services (like V-net) from this RG."
}
variable "existing_v_net_name" {
  type        = string
  description = "This is the name of the existing V-Net."
}
variable "postgresql_dedicated_subnet_name" {
  type        = string
  description = "Name of an exising Subnet."
}
variable "private_dns_name" {
  type        = string
  description = "This is the name of the private DNS needed for PostgreSQL server."
}
variable "private_dns_v_net_link" {
  type        = string
  description = "Private DNS virtual network link name."
}

variable "tags" {
  type        = map(any)
  description = "A mapping of tags to assign to the resources."
  default     = {}
}
