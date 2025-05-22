variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "prefix" {
  description = "Prefix to use for resource names"
  type        = string
}

# Hub Network variables
variable "hub_vnet_address_space" {
  description = "Address space for Hub VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "hub_bastion_subnet_address_prefix" {
  description = "Address prefix for Azure Bastion subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "hub_gateway_subnet_address_prefix" {
  description = "Address prefix for Gateway subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "hub_shared_services_subnet_address_prefix" {
  description = "Address prefix for Shared Services subnet"
  type        = string
  default     = "10.0.2.0/24"
}

# ML Services Network variables
variable "ml_services_vnet_address_space" {
  description = "Address space for ML Services VNet"
  type        = string
  default     = "10.1.0.0/16"
}

variable "ml_compute_subnet_address_prefix" {
  description = "Address prefix for ML Compute subnet"
  type        = string
  default     = "10.1.0.0/22"
}

variable "ml_services_subnet_address_prefix" {
  description = "Address prefix for ML Services subnet"
  type        = string
  default     = "10.1.4.0/22"
}

variable "ml_private_endpoint_subnet_address_prefix" {
  description = "Address prefix for ML Private Endpoint subnet"
  type        = string
  default     = "10.1.8.0/24"
}

# Data Services Network variables
variable "data_services_vnet_address_space" {
  description = "Address space for Data Services VNet"
  type        = string
  default     = "10.2.0.0/16"
}

variable "data_storage_subnet_address_prefix" {
  description = "Address prefix for Data Storage subnet"
  type        = string
  default     = "10.2.0.0/22"
}

variable "database_subnet_address_prefix" {
  description = "Address prefix for Database subnet"
  type        = string
  default     = "10.2.4.0/22"
}

variable "data_private_endpoint_subnet_address_prefix" {
  description = "Address prefix for Data Private Endpoint subnet"
  type        = string
  default     = "10.2.8.0/24"
}

# Analytics Network variables
variable "analytics_vnet_address_space" {
  description = "Address space for Analytics VNet"
  type        = string
  default     = "10.3.0.0/16"
}

variable "analytics_services_subnet_address_prefix" {
  description = "Address prefix for Analytics Services subnet"
  type        = string
  default     = "10.3.0.0/22"
}

variable "data_factory_subnet_address_prefix" {
  description = "Address prefix for Data Factory subnet"
  type        = string
  default     = "10.3.4.0/22"
}

variable "analytics_private_endpoint_subnet_address_prefix" {
  description = "Address prefix for Analytics Private Endpoint subnet"
  type        = string
  default     = "10.3.8.0/24"
}
