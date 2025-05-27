variable "prefix" {
  description = "Prefix for all resources"
  type        = string
}

variable "environment" {
  description = "Environment name for resource naming"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}

variable "current_user_object_id" {
  description = "Object ID of the current user"
  type        = string
}

variable "shared_subnet_id" {
  description = "ID of the shared services subnet"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 30
}

variable "admin_email" {
  description = "Email address for admin notifications"
  type        = string
}

variable "fabric_admin_members" {
  description = "List of admin member object IDs for Fabric capacity"
  type        = list(string)
}
