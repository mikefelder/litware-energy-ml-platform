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