# RBAC module - manages Azure role assignments

# Assign Contributor role to admin group for each resource group
resource "azurerm_role_assignment" "admin_contributor" {
  for_each             = var.resource_group_ids
  scope                = each.value
  role_definition_name = "Contributor"
  principal_id         = var.admin_group_object_id
}

# Assign Owner role to current user for each resource group
resource "azurerm_role_assignment" "owner_current_user" {
  for_each             = var.resource_group_ids
  scope                = each.value
  role_definition_name = "Owner"
  principal_id         = var.current_user_object_id
}

# Storage account role assignments
resource "azurerm_role_assignment" "storage_admin_group" {
  count                = var.storage_account_id != "" ? 1 : 0
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.admin_group_object_id
}

resource "azurerm_role_assignment" "storage_owner_user" {
  count                = var.storage_account_id != "" ? 1 : 0
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.current_user_object_id
}

# ML Workspace role assignments
resource "azurerm_role_assignment" "ml_workspace_admin_group" {
  count                = var.workspace_id != "" ? 1 : 0
  scope                = var.workspace_id
  role_definition_name = "Contributor"
  principal_id         = var.admin_group_object_id
}

resource "azurerm_role_assignment" "ml_workspace_owner_user" {
  count                = var.workspace_id != "" ? 1 : 0
  scope                = var.workspace_id
  role_definition_name = "Owner"
  principal_id         = var.current_user_object_id
}
