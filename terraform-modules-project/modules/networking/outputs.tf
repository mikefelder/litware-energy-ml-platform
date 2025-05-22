output "hub_vnet_id" {
  description = "ID of the Hub Virtual Network"
  value       = azurerm_virtual_network.hub.id
}

output "hub_vnet_name" {
  description = "Name of the Hub Virtual Network"
  value       = azurerm_virtual_network.hub.name
}

output "ml_services_vnet_id" {
  description = "ID of the ML Services Virtual Network"
  value       = azurerm_virtual_network.ml_services.id
}

output "ml_services_vnet_name" {
  description = "Name of the ML Services Virtual Network"
  value       = azurerm_virtual_network.ml_services.name
}

output "data_services_vnet_id" {
  description = "ID of the Data Services Virtual Network"
  value       = azurerm_virtual_network.data_services.id
}

output "data_services_vnet_name" {
  description = "Name of the Data Services Virtual Network"
  value       = azurerm_virtual_network.data_services.name
}

output "analytics_vnet_id" {
  description = "ID of the Analytics Virtual Network"
  value       = azurerm_virtual_network.analytics.id
}

output "analytics_vnet_name" {
  description = "Name of the Analytics Virtual Network"
  value       = azurerm_virtual_network.analytics.name
}

output "ml_compute_subnet_id" {
  description = "ID of the ML Compute subnet"
  value       = azurerm_subnet.ml_compute.id
}

output "ml_services_subnet_id" {
  description = "ID of the ML Services subnet"
  value       = azurerm_subnet.ml_services.id
}

output "data_storage_subnet_id" {
  description = "ID of the Data Storage subnet"
  value       = azurerm_subnet.data_storage.id
}

output "database_subnet_id" {
  description = "ID of the Database subnet"
  value       = azurerm_subnet.database.id
}

output "analytics_services_subnet_id" {
  description = "ID of the Analytics Services subnet"
  value       = azurerm_subnet.analytics_services.id
}

output "data_factory_subnet_id" {
  description = "ID of the Data Factory subnet"
  value       = azurerm_subnet.data_factory.id
}

output "bastion_subnet_id" {
  description = "ID of the Azure Bastion subnet"
  value       = azurerm_subnet.bastion.id
}

output "gateway_subnet_id" {
  description = "ID of the Gateway subnet"
  value       = azurerm_subnet.gateway.id
}

output "shared_services_subnet_id" {
  description = "ID of the Shared Services subnet"
  value       = azurerm_subnet.shared_services.id
}
