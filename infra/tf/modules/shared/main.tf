# Shared services infrastructure

locals {
  region_short = substr(replace(lower(var.location), " ", ""), 0, 2)
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = module.naming.log_analytics_workspace.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
  tags                = var.tags
}

# Key Vault
resource "azurerm_key_vault" "main" {
  name                = "kvlitwml${var.environment}${local.region_short}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = "standard"

  purge_protection_enabled = true

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    virtual_network_subnet_ids = [var.shared_subnet_id]
  }

  tags = var.tags
}

# Key Vault access policy for current user
resource "azurerm_key_vault_access_policy" "current_user" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = var.tenant_id
  object_id    = var.current_user_object_id

  key_permissions = [
    "Get", "List", "Create", "Delete", "Update",
  ]

  secret_permissions = [
    "Get", "List", "Set", "Delete",
  ]

  certificate_permissions = [
    "Get", "List", "Create", "Delete", "Update",
  ]
}

# Application Insights
resource "azurerm_application_insights" "main" {
  name                = module.naming.application_insights.name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.main.id

  tags = var.tags
}

# Naming module
module "naming" {
  source = "../naming"
  suffix = [var.environment]
}

resource "azurerm_fabric_capacity" "fabric" {
  name                = "fablitwml${var.environment}${local.region_short}"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name = "F2"
    tier = "Fabric"
  }

  administration_members = var.fabric_admin_members
  tags                   = var.tags
}

# Azure Monitor Action Group
resource "azurerm_monitor_action_group" "main" {
  name                = module.naming.monitor_action_group.name
  resource_group_name = var.resource_group_name
  short_name          = "mainaction"

  email_receiver {
    name          = "admins"
    email_address = var.admin_email
  }

  tags = var.tags
}
