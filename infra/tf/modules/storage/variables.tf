//TODO: Do we need this module? Move to the root module?
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "naming_module_suffix" {
  description = "Suffix to be used with the naming module"
  type        = list(string)
  default     = ["litware", "poc"]
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "prefix" {
  description = "Prefix to use for resource names"
  type        = string
  default     = "litware"
}

variable "subnet_ids" {
  description = "List of subnet IDs that are allowed to access the storage account"
  type        = list(string)
  default     = []
}

variable "private_endpoint_subnet_id" {
  description = "ID of the subnet for private endpoints"
  type        = string
}

variable "private_dns_zone_ids" {
  description = "Map of private DNS zone IDs for storage endpoints"
  type        = map(string)
}
