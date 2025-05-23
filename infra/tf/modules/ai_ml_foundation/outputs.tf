output "workspace_id" {
  description = "ID of the Machine Learning Workspace"
  value       = azurerm_machine_learning_workspace.mlw.id
}

output "storage_account_id" {
  description = "ID of the storage account used for ML workspace"
  value       = azurerm_storage_account.mlstorage.id
}

output "container_registry_id" {
  description = "ID of the container registry"
  value       = azurerm_container_registry.mlacr.id
}

output "compute_cluster_id" {
  description = "ID of the compute cluster"
  value       = azurerm_machine_learning_compute_cluster.compute.id
}

output "workspace_principal_id" {
  description = "The principal ID of the ML workspace managed identity"
  value       = azurerm_machine_learning_workspace.mlw.identity[0].principal_id
}
