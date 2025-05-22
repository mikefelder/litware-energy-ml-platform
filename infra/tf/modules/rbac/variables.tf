# Required variables
variable "resource_group_ids" {
  description = "Map of resource group names to their IDs"
  type        = map(string)
}

variable "admin_group_object_id" {
  description = "Object ID of the Azure AD group to assign Contributor access"
  type        = string
}

variable "current_user_object_id" {
  description = "Object ID of the current user"
  type        = string
}

variable "workspace_id" {
  description = "ID of the Machine Learning workspace"
  type        = string
  default     = "" # Make this optional since ML workspace might not exist yet
}

variable "storage_account_id" {
  description = "ID of the storage account"
  type        = string
}