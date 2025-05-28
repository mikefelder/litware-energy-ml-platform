output "data_factory" {
  value       = local.az.data_factory
  description = "Naming conventions for Data Factory resources"
}

output "machine_learning_workspace" {
  value       = local.az.machine_learning_workspace
  description = "Naming conventions for Machine Learning Workspace resources"
}

output "databricks_workspace" {
  value       = local.az.databricks_workspace
  description = "Naming conventions for Databricks Workspace resources"
}

output "synapse_workspace" {
  value       = local.az.synapse_workspace
  description = "Naming conventions for Synapse Workspace resources"
}

output "analysis_services_server" {
  value       = local.az.analysis_services_server
  description = "Naming conventions for Analysis Services Server resources"
}

output "naming_rules" {
  description = "Naming rules for analytics services"
  value = {
    data_factory             = local.az.data_factory
    machine_learning_workspace = local.az.machine_learning_workspace
    databricks_workspace     = local.az.databricks_workspace
    synapse_workspace       = local.az.synapse_workspace
    analysis_services_server = local.az.analysis_services_server
    log_analytics_workspace  = local.az.log_analytics_workspace
    monitor_action_group    = local.az.monitor_action_group
    fabric_capacity         = local.az.fabric_capacity,
    application_insights    = local.az.application_insights
    application_insights    = local.az.application_insights
  }
}