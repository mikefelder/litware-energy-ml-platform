output "eventhub_namespace_id" {
  description = "ID of the Event Hub Namespace"
  value       = azurerm_eventhub_namespace.main.id
}

output "eventhub_sensor_data_id" {
  description = "ID of the sensor data Event Hub"
  value       = azurerm_eventhub.sensor_data.id
}

output "datalake_id" {
  description = "ID of the Data Lake Storage account"
  value       = azurerm_storage_account.datalake.id
}

output "datalake_name" {
  description = "Name of the Data Lake Storage account"
  value       = azurerm_storage_account.datalake.name
}

output "servicebus_namespace_id" {
  description = "ID of the Service Bus Namespace"
  value       = azurerm_servicebus_namespace.main.id
}

output "data_factory_id" {
  description = "ID of the Data Factory"
  value       = azurerm_data_factory.main.id
}

output "data_factory_identity" {
  description = "Identity of the Data Factory"
  value       = azurerm_data_factory.main.identity[0].principal_id
}
