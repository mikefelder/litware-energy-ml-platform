locals {
  # Resource group naming
  core_networking_rg_name  = "rg-core-networking"
  shared_services_rg_name  = "rg-shared-services"
  ai_ml_foundation_rg_name = "rg-ai-ml-foundation"
  data_ingestion_rg_name   = "rg-data-ingestion"
  vignette_pred_maint_name = "rg-vignette-predictive-maintenance"
  vignette_emissions_name  = "rg-vignette-emissions-tracking"
  vignette_genai_name      = "rg-vignette-genai-fieldops"
  vignette_trading_name    = "rg-vignette-trading-analytics"

  # Tags
  tags = {
    Company     = var.company_name
    CostCenter  = var.cost_center
    Environment = var.environment
    Owner       = var.owner
    Project     = var.project_name
  }
}

# Outputs for use in other modules
output "resource_group_names" {
  value = {
    core_networking  = local.core_networking_rg_name
    shared_services  = local.shared_services_rg_name
    ai_ml_foundation = local.ai_ml_foundation_rg_name
    data_ingestion   = local.data_ingestion_rg_name
    pred_maint       = local.vignette_pred_maint_name
    emissions        = local.vignette_emissions_name
    genai           = local.vignette_genai_name
    trading         = local.vignette_trading_name
  }
  description = "Map of resource group names"
}

output "tags" {
  value       = local.tags
  description = "Common tags to be applied to all resources"
}

output "environment" {
  value       = var.environment
  description = "Environment name"
}

output "prefix" {
  value       = var.prefix
  description = "Resource naming prefix"
}
