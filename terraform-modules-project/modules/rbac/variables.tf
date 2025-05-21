variable "role_definition_name" {
  description = "The name of the role definition to assign."
  type        = string
}

variable "principal_id" {
  description = "The object ID of the principal (user or group) to assign the role to."
  type        = string
}

variable "scope" {
  description = "The scope at which the role assignment applies."
  type        = string
}

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
}

variable "storage_account_id" {
  description = "ID of the storage account"
  type        = string
}