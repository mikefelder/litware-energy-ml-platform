# Required variables
variable "resource_group_ids" {
  description = "Map of resource group names to their IDs"
  type        = map(string)
}

variable "admin_group_id" {
  description = "Object ID of the Azure AD admin group to assign Contributor access"
  type        = string
}

variable "current_user_object_id" {
  description = "Object ID of the current user who will be assigned Owner access"
  type        = string
}

variable "network_admins_group_name" {
  description = "Name for the network administrators AAD group that will manage private endpoints"
  type        = string
  default     = "Litware-AIML-Team-network-admins"
}

variable "ml_workspace_ids" {
  description = "Map of ML workspace names to their IDs for RBAC role assignments"
  type        = map(string)
  default     = {}
}

# Optional storage account variables
variable "storage_account_id" {
  description = "ID of the main storage account for data storage"
  type        = string
  default     = null
}

variable "ml_storage_account_id" {
  description = "ID of the ML workspace storage account for model artifacts"
  type        = string
  default     = null
}

variable "ai_storage_account_id" {
  description = "ID of the AI services storage account for cognitive services data"
  type        = string
  default     = null
}

variable "datalake_storage_account_id" {
  description = "ID of the data lake storage account for large-scale data storage"
  type        = string
  default     = null
}

variable "ml_workspace_principal_id" {
  description = "The principal ID of the ML workspace managed identity"
  type        = string
  default     = null
}