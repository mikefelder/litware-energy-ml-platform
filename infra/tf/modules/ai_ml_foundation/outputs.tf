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
