output "machine_learning_endpoint" {
  description = "The endpoint URL of the Azure Machine Learning service"
  value       = azurerm_cognitive_account.machine_learning.endpoint
}

output "openai_endpoint" {
  description = "The endpoint URL of the OpenAI service"
  value       = azurerm_cognitive_account.openai.endpoint
}

output "document_intelligence_endpoint" {
  description = "The endpoint URL of the Document Intelligence service"
  value       = azurerm_cognitive_account.document_intelligence.endpoint
}

output "search_endpoint" {
  description = "The endpoint URL of the Azure AI Search service"
  value       = "https://${azurerm_search_service.search.name}.search.windows.net"
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.ai_storage.name
}

output "storage_account_id" {
  description = "The ID of the AI services storage account"
  value       = azurerm_storage_account.ai_storage.id
}
