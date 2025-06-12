# RBAC module - manages Azure role assignments

locals {
  # Storage admin role definitions
  storage_roles = [
    {
      role_def_name = "Storage Blob Data Contributor"
      suffix        = "blob"
    },
    {
      role_def_name = "Storage Queue Data Contributor"  
      suffix        = "queue"
    },
    {
      role_def_name = "Storage Table Data Contributor"
      suffix        = "table" 
    },
    {
      role_def_name = "Storage File Data SMB Share Contributor"
      suffix        = "file"
    }
  ]
}

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

# Create network admins group for managing private endpoints
resource "azuread_group" "network_admins" {
  display_name     = var.network_admins_group_name
  security_enabled = true
}

locals {
  # Extract clean UUID by removing all non-UUID characters
  network_admins_group_id = regex("[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}", azuread_group.network_admins.id)
}

# Add current user to network admins group
resource "azuread_group_member" "current_user_network_admin" {
  group_object_id  = local.network_admins_group_id
  member_object_id = data.azurerm_client_config.current.object_id
}

# Assign Private DNS Zone Contributor role to network admins group
resource "azurerm_role_assignment" "network_admins_endpoints" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = local.network_admins_group_id
}

# ML team AAD group memberships
resource "azurerm_role_assignment" "ml_workspace_owner_user" {
  for_each = var.ml_workspace_ids

  scope                = each.value
  role_definition_name = "Owner"
  principal_id         = var.current_user_object_id  
}

resource "azurerm_role_assignment" "ml_workspace_admin_group" {
  for_each = var.ml_workspace_ids

  scope                = each.value
  role_definition_name = "Contributor"
  principal_id         = var.admin_group_id  
}

# Main storage account role assignments
resource "azurerm_role_assignment" "main_storage_roles" {
  count = length(local.storage_roles)

  scope                = var.storage_account_id
  role_definition_name = local.storage_roles[count.index].role_def_name
  principal_id         = var.admin_group_id
}

# ML storage account role assignments 
resource "azurerm_role_assignment" "ml_storage_roles" {
  count = length(local.storage_roles)

  scope                = var.ml_storage_account_id
  role_definition_name = local.storage_roles[count.index].role_def_name
  principal_id         = var.admin_group_id
}

# AI storage account role assignments
resource "azurerm_role_assignment" "ai_storage_roles" {
  count = length(local.storage_roles)

  scope                = var.ai_storage_account_id
  role_definition_name = local.storage_roles[count.index].role_def_name
  principal_id         = var.admin_group_id
}

# Data lake storage account role assignments
resource "azurerm_role_assignment" "datalake_storage_roles" {
  count = length(local.storage_roles)

  scope                = var.datalake_storage_account_id
  role_definition_name = local.storage_roles[count.index].role_def_name
  principal_id         = var.admin_group_id
}

# Resource group role assignments
resource "azurerm_role_assignment" "owner_current_user" {
  for_each = var.resource_group_ids

  scope                = each.value
  role_definition_name = "Owner"
  principal_id         = var.current_user_object_id
}

resource "azurerm_role_assignment" "admin_contributor" {
  for_each = var.resource_group_ids

  scope                = each.value
  role_definition_name = "Contributor"
  principal_id         = var.admin_group_id
}
