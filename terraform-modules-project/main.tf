# Local values for resource naming and organization
locals {
  name_prefix         = "litwareaiml"
  resource_group_name = "litware-aiml-rg"
  workspace_name      = "litware-aiml-workspace"
}

# Data sources
data "azurerm_client_config" "current" {}

# Modules
module "naming" {
  source = "./modules/naming"
  suffix = ["litware", "poc"]
}

module "identity" {
  source        = "./modules/identity"
  tenant_domain = var.tenant_domain
}

# Create resource group
module "resource_group" {
  source   = "./modules/resource_group"
  name     = local.resource_group_name
  location = var.location
  tags     = var.tags
}

# Create networking infrastructure
module "networking" {
  source              = "./modules/networking"
  resource_group_name = module.resource_group.name
  location           = var.location
  environment        = "prod"
  prefix             = local.name_prefix
  tags               = var.tags

  # Hub Network configuration (using defaults for subnets)
  hub_vnet_address_space = "10.0.0.0/16"

  # ML Services Network configuration
  ml_services_vnet_address_space = "10.1.0.0/16"

  # Data Services Network configuration
  data_services_vnet_address_space = "10.2.0.0/16"

  # Analytics Network configuration
  analytics_vnet_address_space = "10.3.0.0/16"
}

module "storage" {
  source              = "./modules/storage"
  location            = var.location
  resource_group_name = module.resource_group.name
  environment         = "prod"
  prefix              = local.name_prefix
  tags                = var.tags
}

# RBAC assignments
resource "azurerm_role_assignment" "admin_contributor" {
  scope                = module.resource_group.id
  role_definition_name = "Contributor"
  principal_id         = module.identity.ml_team_group_id
}

resource "azurerm_role_assignment" "owner_current_user" {
  scope                = module.resource_group.id
  role_definition_name = "Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "storage_admin_group" {
  scope                = module.storage.ml_storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.identity.ml_team_group_id
}

resource "azurerm_role_assignment" "storage_owner_user" {
  scope                = module.storage.ml_storage_account_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

//TODO: Move to the root output module?
output "ml_users_credentials" {
  value       = module.identity.ml_users_credentials
  sensitive   = true
  description = "Initial credentials for POC ML users."
}
