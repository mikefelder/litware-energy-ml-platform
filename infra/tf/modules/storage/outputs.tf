//TODO: Do we need this module? Move to the root output module?
output "storage_account_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.ml.id
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.ml.name
}

output "datasets_container_name" {
  description = "Name of the datasets container"
  value       = azurerm_storage_container.datasets.name
}

output "models_container_name" {
  description = "Name of the models container"
  value       = azurerm_storage_container.models.name
}

output "notebooks_container_name" {
  description = "Name of the notebooks container"
  value       = azurerm_storage_container.notebooks.name
}

output "ml_storage_account_id" {
  description = "The ID of the ML Storage Account"
  value       = azurerm_storage_account.ml.id
}

output "ml_storage_account_name" {
  description = "The name of the ML Storage Account"
  value       = azurerm_storage_account.ml.name
}
