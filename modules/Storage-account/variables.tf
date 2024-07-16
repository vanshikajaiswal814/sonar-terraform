variable "whitelist_ip_ranges" {
  description = "list of whitelisted public ip ranges"
  type        = list(string)
  default = ["209.221.240.184",
    "177.11.252.18",
    "139.15.142.49",
    "103.205.152.154",
    "194.39.218.23",
    "45.112.37.64",
    "139.15.98.128",
    "194.39.218.20",
    "209.221.240.153",
    "194.39.218.19",
    "119.40.64.9",
    "139.15.3.133",
    "119.40.69.128",
    "119.40.64.26",
    "194.39.218.13",
    "194.39.218.17",
    "103.4.125.23",
    "170.245.134.184",
    "195.11.167.73",
    "194.39.218.14",
    "45.112.38.96",
    "119.40.9.128",
    "209.221.242.192",
    "103.4.125.25",
    "194.39.218.11",
    "209.221.240.192",
    "209.221.240.196",
    "119.40.64.224",
    "103.205.152.156",
    "177.11.252.23",
    "47.88.93.169",
    "103.4.127.176",
    "103.4.125.26",
    "119.40.64.12",
    "194.39.218.12",
    "119.40.72.61",
    "208.44.45.133",
    "103.205.152.155",
    "177.11.252.56",
    "177.11.252.15",
    "194.39.218.18",
    "103.205.152.157",
    "139.15.98.0",
    "194.39.218.21",
    "209.221.240.152",
    "103.205.153.48",
    "194.39.218.22",
    "194.39.218.10",
    "202.111.0.160",
    "194.39.218.15",
    "119.40.64.15",
    "216.213.57.133",
    "103.221.241.133",
    "194.39.218.16",
    "104.45.45.134",
    "139.15.8.8"]
}

variable "existing_v_net_name" {
  type        = string
  description = "resource group and AKS virtual network"
}

variable "managed_resource_group" {
  type        = string
  description = "resource group of AKS cluster"
}

variable "aks1_subnet" {
  type        = string
  description = "subnet 1 of AKS cluster"
  default     = "zBdcAksSubnet01"
}

variable "aks2_subnet" {
  type        = string
  description = "subnet 2 of AKS cluster"
  default     = "zBdcAksSubnet02"
}

variable "default_subnet" {
  type        = string
  description = "vnet default subnet"
  default     = "DefaultSubnet"
}

variable "storage_account_name" {
  type        = string
  description = "name of storage account"
}

variable "deployment_resource_group" {
  type        = string
  description = "resource group of storage account"
}

variable "location" {
  type        = string
  description = "azure location where the resource exists"
}

variable "account_tier" {
  type        = string
  description = "Tier to use for the storage account"
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = "defines the type of replication to use for the storage account"
  default     = "RAGRS"
}

variable "min_tls_version" {
  type        = string
  description = "minimum supported TLS version for the storage account"
  default     = "TLS1_2"
}

variable "enable_https_traffic_only" {
  type        = string
  description = "Boolean flag which forces HTTPS if enabled"
  default     = true
}

variable "bypass" {
  type        = list(string)
  description = "Specifies whether traffic is bypassed for Logging/Metrics/AzureServices"
  default     = ["AzureServices", "Logging", "Metrics"]
}

variable "default_action" {
  type        = string
  description = "Specifies the default action of allow or deny when no other rules match"
  default     = "Deny"
}

variable "identity_type" {
  type        = string
  description = ""
  default     = "SystemAssigned"
}

variable "share_name" {
  type        = string
  description = "name of the azure file share"
}

variable "key_vault" {
  type        = string
  description = "Contains name of the keyvault to be used for secret creation."
}

variable "customer_managed_key" {
  type        = string
  description = "customer managed key for storage account."
}

variable "quota" {
  type        = string
  description = "the provisioned capacity of the file share"
  default     = 50
}

variable "private_endpoint_name" {
  type        = string
  description = "name of the private endpoint"
  default     = "cfw-st-endpoint"
}

variable "private_service_connection_name" {
  type        = string
  description = "name of the private service connection"
  default     = "cfw-connection"
}

variable "is_manual_connection" {
  type        = string
  description = "manual approval from the remote resource owner"
  default     = false
}

variable "subresource_names" {
  type        = list(string)
  description = "subresource names which the Private Endpoint is able to connect to"
  default     = ["file"]
}

variable "storage_account_private_dns_name" {
  type        = string
  description = "This is the private DNS name required for ACR."
}
