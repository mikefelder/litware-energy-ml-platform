# Local values for resource naming and organization
locals {
  prefix                   = "litware"
  core_networking_rg_name  = "rg-core-networking"
  shared_services_rg_name  = "rg-shared-services"
  ai_ml_foundation_rg_name = "rg-ai-ml-foundation"
  data_ingestion_rg_name   = "rg-data-ingestion"
  vignette_pred_maint_name = "rg-vignette-predictive-maintenance"
  vignette_emissions_name  = "rg-vignette-emissions-tracking"
  vignette_genai_name      = "rg-vignette-genai-fieldops"
  vignette_trading_name    = "rg-vignette-trading-analytics"
  environment              = "prod"
}

# Data sources
data "azurerm_client_config" "current" {}

# Foundation Resource Groups
module "rg_networking" {
  source   = "./modules/resource_group"
  name     = local.core_networking_rg_name
  location = var.location
  tags     = var.tags
}

module "rg_shared" {
  source   = "./modules/resource_group"
  name     = local.shared_services_rg_name
  location = var.location
  tags     = var.tags
}

# Networking
module "networking" {
  source              = "./modules/networking"
  prefix              = local.prefix
  environment         = local.environment
  location            = var.location
  resource_group_name = module.rg_networking.name
  tags                = var.tags
}

# Identity (existing)
module "identity" {
  source        = "./modules/identity"
  tenant_domain = var.tenant_domain
}

# Shared Services
module "shared" {
  source                 = "./modules/shared"
  prefix                 = local.prefix
  environment            = local.environment
  location               = var.location
  resource_group_name    = module.rg_shared.name
  tags                   = var.tags
  tenant_id              = data.azurerm_client_config.current.tenant_id
  current_user_object_id = data.azurerm_client_config.current.object_id
  shared_subnet_id       = module.networking.subnet_ids["SharedServicesSubnet"]
  admin_email            = var.admin_email
}

# AI/ML Foundation Resource Group
module "rg_ai_ml" {
  source   = "./modules/resource_group"
  name     = local.ai_ml_foundation_rg_name
  location = var.location
  tags     = var.tags
}

# Data Ingestion Resource Group
module "rg_data_ingestion" {
  source   = "./modules/resource_group"
  name     = local.data_ingestion_rg_name
  location = var.location
  tags     = var.tags
}

# Vignette Resource Groups
module "rg_predictive_maintenance" {
  source   = "./modules/resource_group"
  name     = local.vignette_pred_maint_name
  location = var.location
  tags     = var.tags
}

module "rg_emissions_tracking" {
  source   = "./modules/resource_group"
  name     = local.vignette_emissions_name
  location = var.location
  tags     = var.tags
}

module "rg_genai_fieldops" {
  source   = "./modules/resource_group"
  name     = local.vignette_genai_name
  location = var.location
  tags     = var.tags
}

module "rg_trading_analytics" {
  source   = "./modules/resource_group"
  name     = local.vignette_trading_name
  location = var.location
  tags     = var.tags
}

# Data Ingestion
module "data_ingestion" {
  source              = "./modules/data_ingestion"
  prefix              = local.prefix
  environment         = local.environment
  location            = var.location
  resource_group_name = module.rg_data_ingestion.name
  tags                = var.tags
  subnet_id           = module.networking.subnet_ids["SharedServicesSubnet"]
  tenant_id           = data.azurerm_client_config.current.tenant_id
  devops_project      = var.devops_project
}

# AI/ML Foundation
module "ai_ml_foundation" {
  source                  = "./modules/ai_ml_foundation"
  prefix                  = local.prefix
  environment             = local.environment
  location                = var.location
  resource_group_name     = module.rg_ai_ml.name
  tags                    = var.tags
  subnet_id               = module.networking.subnet_ids["SharedServicesSubnet"]
  key_vault_id            = module.shared.key_vault_id
  application_insights_id = module.shared.app_insights_id
}

# RBAC Management
module "rbac" {
  source = "./modules/rbac"

  resource_group_ids = {
    networking         = module.rg_networking.id
    shared             = module.rg_shared.id
    ai_ml_foundation   = module.rg_ai_ml.id
    data_ingestion     = module.rg_data_ingestion.id
    pred_maintenance   = module.rg_predictive_maintenance.id
    emissions_tracking = module.rg_emissions_tracking.id
    genai_fieldops     = module.rg_genai_fieldops.id
    trading_analytics  = module.rg_trading_analytics.id
  }

  admin_group_object_id  = module.identity.ml_team_group_id
  current_user_object_id = data.azurerm_client_config.current.object_id
  storage_account_id     = "" # Will add after ML foundation deployment
  workspace_id           = "" # Will add after ML foundation deployment
}

# Outputs
output "ml_users_credentials" {
  value       = module.identity.ml_users_credentials
  sensitive   = true
  description = "Initial credentials for POC ML users."
}
