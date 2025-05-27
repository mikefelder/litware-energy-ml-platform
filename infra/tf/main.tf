# Configuration module
module "config" {
  source = "./modules/config"
}

# Data sources
# Note: Moved the client_config data source to the identity module where it's most relevant

# Foundation Resource Groups
module "rg_networking" {
  source   = "./modules/resource_group"
  name     = module.config.resource_group_names["core_networking"]
  location = var.location
  tags     = module.config.tags
}

module "rg_shared" {
  source   = "./modules/resource_group"
  name     = module.config.resource_group_names["shared_services"]
  location = var.location
  tags     = module.config.tags
}

# Networking
module "networking" {
  source              = "./modules/networking"
  prefix              = module.config.prefix
  environment         = module.config.environment
  location            = var.location
  resource_group_name = module.rg_networking.name
  tags                = module.config.tags
}

# Identity (existing)
module "identity" {
  source        = "./modules/identity"
  tenant_domain = var.tenant_domain
}

# Shared Services
module "shared" {
  source                 = "./modules/shared"
  prefix                 = module.config.prefix
  environment            = module.config.environment
  location               = var.location
  resource_group_name    = module.rg_shared.name
  tags                   = module.config.tags
  shared_subnet_id       = module.networking.subnet_ids["SharedServicesSubnet"]
  admin_email            = var.admin_email
  fabric_admin_members   = [var.admin_email] # Current user as admin
  tenant_id              = module.identity.tenant_id
  current_user_object_id = module.identity.current_user_object_id
}

# AI/ML Foundation Resource Group
module "rg_ai_ml" {
  source   = "./modules/resource_group"
  name     = module.config.resource_group_names["ai_ml_foundation"]
  location = var.location
  tags     = module.config.tags
}

# Data Ingestion Resource Group
module "rg_data_ingestion" {
  source   = "./modules/resource_group"
  name     = module.config.resource_group_names["data_ingestion"]
  location = var.location
  tags     = module.config.tags
}

# Vignette Resource Groups
module "rg_predictive_maintenance" {
  source   = "./modules/resource_group"
  name     = module.config.resource_group_names["pred_maint"]
  location = var.location
  tags     = module.config.tags
}

module "rg_emissions_tracking" {
  source   = "./modules/resource_group"
  name     = module.config.resource_group_names["emissions"]
  location = var.location
  tags     = module.config.tags
}

module "rg_genai_fieldops" {
  source   = "./modules/resource_group"
  name     = module.config.resource_group_names["genai"]
  location = var.location
  tags     = module.config.tags
}

module "rg_trading_analytics" {
  source   = "./modules/resource_group"
  name     = module.config.resource_group_names["trading"]
  location = var.location
  tags     = module.config.tags
}

# Data Ingestion
module "data_ingestion" {
  source                     = "./modules/data_ingestion"
  prefix                     = module.config.prefix
  environment                = module.config.environment
  location                   = var.location
  resource_group_name        = module.rg_data_ingestion.name
  tags                       = module.config.tags
  subnet_id                  = module.networking.subnet_ids["SharedServicesSubnet"]
  tenant_id                  = module.identity.tenant_id
  devops_project             = var.devops_project
  private_endpoint_subnet_id = module.networking.ai_services_private_endpoints_subnet_id
  private_dns_zone_ids       = module.dns.private_dns_zone_ids
}

# AI/ML Foundation
module "ai_ml_foundation" {
  source                     = "./modules/ai_ml_foundation"
  prefix                     = module.config.prefix
  environment                = module.config.environment
  location                   = var.location
  resource_group_name        = module.rg_ai_ml.name
  tags                       = module.config.tags
  subnet_id                  = module.networking.subnet_ids["SharedServicesSubnet"]
  key_vault_id               = module.shared.key_vault_id
  application_insights_id    = module.shared.app_insights_id
  private_endpoint_subnet_id = module.networking.ai_services_private_endpoints_subnet_id
  private_dns_zone_ids       = module.dns.private_dns_zone_ids
}

# AI Services Resource Group
module "rg_ai_services" {
  source   = "./modules/resource_group"
  name     = "ai-services"
  location = var.ai_services_location
  tags     = module.config.tags
}

# RBAC Management
module "rbac" {
  source = "./modules/rbac"

  # Resource Group Assignments
  resource_group_ids = {
    "shared"           = module.rg_shared.id
    "networking"       = module.rg_networking.id
    "data_ingestion"   = module.rg_data_ingestion.id
    "ai_ml_foundation" = module.rg_ai_ml.id
    "ai_services"      = module.rg_ai_services.id
  }

  # Admin Group Config
  admin_group_id         = module.identity.ml_team_group_id
  current_user_object_id = module.identity.current_user_object_id

  # Storage Account IDs  
  storage_account_id          = module.storage.storage_account_id
  ml_storage_account_id       = module.ai_ml_foundation.storage_account_id
  ai_storage_account_id       = module.ai_services.storage_account_id
  datalake_storage_account_id = module.data_ingestion.datalake_storage_account_id

  # ML Workspace Config
  ml_workspace_ids = {
    main = module.ai_ml_foundation.workspace_id
  }
  ml_workspace_principal_id = module.ai_ml_foundation.workspace_principal_id

  depends_on = [
    module.ai_ml_foundation,
    module.storage,
    module.ai_services,
    module.data_ingestion
  ]
}

# DNS Management Module
module "dns" {
  source              = "./modules/dns"
  resource_group_name = module.rg_networking.name
  ai_services_vnet_id = module.networking.ai_services_vnet_id
  tags                = module.config.tags
}

# AI Services Module
module "ai_services" {
  source                     = "./modules/ai_services"
  prefix                     = module.config.prefix
  environment                = module.config.environment
  location                   = var.ai_services_location
  location_secondary         = var.ai_services_location_secondary
  resource_group_name        = module.rg_ai_services.name
  tags                       = module.config.tags
  subnet_id                  = module.networking.subnet_ids["SharedServicesSubnet"]
  private_endpoint_subnet_id = module.networking.ai_services_private_endpoints_subnet_id
  private_dns_zone_ids       = module.dns.private_dns_zone_ids

  log_analytics_workspace_id = module.shared.log_analytics_workspace_id
}

# Single consolidated output for all deployment information
output "deployment_info" {
  value = {
    ml_users_credentials = module.identity.ml_users_credentials,
    resource_group_ids = {
      networking         = module.rg_networking.id,
      shared             = module.rg_shared.id,
      ai_ml_foundation   = module.rg_ai_ml.id,
      data_ingestion     = module.rg_data_ingestion.id,
      pred_maintenance   = module.rg_predictive_maintenance.id,
      emissions_tracking = module.rg_emissions_tracking.id,
      genai_fieldops     = module.rg_genai_fieldops.id,
      trading_analytics  = module.rg_trading_analytics.id
    },
    private_dns_zone_ids = module.dns.private_dns_zone_ids
  }
  description = "All deployment information consolidated in one output"
  sensitive   = true
}

module "storage" {
  source              = "./modules/storage"
  prefix              = module.config.prefix
  environment         = module.config.environment
  location            = var.location
  resource_group_name = module.rg_shared.name
  tags                = module.config.tags
  subnet_ids = [
    module.networking.subnet_ids["SharedServicesSubnet"],
    module.networking.ml_services_subnet_ids["MlServicesSubnet"],
    module.networking.data_services_subnet_ids["StorageSubnet"]
  ]
  private_endpoint_subnet_id = module.networking.ai_services_private_endpoints_subnet_id
  private_dns_zone_ids = {
    "blob"  = module.dns.private_dns_zone_ids["blob"]
    "file"  = module.dns.private_dns_zone_ids["file"]
    "queue" = module.dns.private_dns_zone_ids["queue"]
    "table" = module.dns.private_dns_zone_ids["table"]
  }
}
