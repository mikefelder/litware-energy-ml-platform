variable "prefix" {
  description = "Prefix for all resources"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Primary location for resources"
  type        = string
}

variable "location_secondary" {
  description = "Secondary location for resources that support multi-region deployment"
  type        = string
  default     = "westus2"
}

variable "private_endpoint_subnet_id" {
  description = "ID of the subnet for private endpoints"
  type        = string
}

variable "private_dns_zone_ids" {
  description = "IDs of private DNS zones for private endpoints"
  type        = map(string)
}

variable "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet to deploy the storage account into"
  type        = string
}
