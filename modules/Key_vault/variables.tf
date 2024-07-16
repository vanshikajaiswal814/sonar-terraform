variable "managed_resource_group" {
  type        = string
  description = "Managed Resource group name"
}

variable "deployment_resource_group" {
  type        = string
  description = "Resource group to deploy all azure services"
}

variable "key_vault_default_subnet_name" {
  type        = string
  description = "keyvault default subnet"
}

variable "location" {
  type        = string
  description = "The location of the The resource group."
  default     = ""
}

variable "existing_v_net_name" {
  type        = string
  description = "aks default vnet"
}

variable "default_subnet" {
  type        = string
  description = "vnet default subnet"
  default     = "DefaultSubnet"
}

variable "key_vault_name" {
  type        = string
  description = "keyvault name"
}

variable "sp_devcloud_object_id" {
  description = "sp_devcloud object id"
  default = "3bfab26a-d5d3-43de-bec4-5695ade926df"
}

variable "IDM2BCD_BDC_CloudSpace00167_contributor_object_id" {
  description = "IDM2BCD_BDC_CloudSpace00167_contributor object id"
  default = "edcd74c0-452d-4c94-afa1-cef86ccac12a"
}

variable "tags" {
  type        = map(any)
  description = "A mapping of tags to assign to the resources."
  default     = {}
}

variable "whitelist_ip_ranges" {
  description = "list of whitelisted public ip ranges"
  type        = list(string)
  default = ["209.221.240.184/32",
    "177.11.252.18/32",
    "139.15.142.49/32",
    "103.205.152.154/32",
    "194.39.218.23/32",
    "45.112.37.64/28",
    "139.15.98.128/29",
    "194.39.218.20/32",
    "209.221.240.153/32",
    "194.39.218.19/32",
    "119.40.64.9/32",
    "139.15.3.133/32",
    "119.40.69.128/30",
    "119.40.64.26/32",
    "194.39.218.13/32",
    "194.39.218.17/32",
    "103.4.125.23/32",
    "170.245.134.184/29",
    "195.11.167.73/32",
    "194.39.218.14/32",
    "45.112.38.96/28",
    "119.40.9.128/30",
    "209.221.242.192/28",
    "103.4.125.25/32",
    "194.39.218.11/32",
    "209.221.240.192/29",
    "209.221.240.196/32",
    "119.40.64.224/27",
    "103.205.152.156/32",
    "177.11.252.23/32",
    "47.88.93.169/32",
    "103.4.127.176/32",
    "103.4.125.26/32",
    "119.40.64.12/32",
    "194.39.218.12/32",
    "119.40.72.61/32",
    "208.44.45.133/32",
    "103.205.152.155/32",
    "177.11.252.56/30",
    "177.11.252.15/32",
    "194.39.218.18/32",
    "103.205.152.157/32",
    "139.15.98.0/25",
    "194.39.218.21/32",
    "209.221.240.152/32",
    "103.205.153.48/28",
    "194.39.218.22/32",
    "194.39.218.10/32",
    "202.111.0.160/28",
    "194.39.218.15/32",
    "119.40.64.15/32",
    "216.213.57.133/32",
    "103.221.241.133/32",
    "194.39.218.16/32",
    "104.45.45.134",
    "139.15.8.8/29"]
}
