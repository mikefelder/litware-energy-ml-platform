output "vnet_id" {
  description = "ID of the hub virtual network"
  value       = azurerm_virtual_network.hub.id
}

output "vnet_name" {
  description = "Name of the hub virtual network"
  value       = azurerm_virtual_network.hub.name
}

output "subnet_ids" {
  description = "Map of subnet names to IDs"
  value = {
    for subnet in azurerm_subnet.hub_subnets : subnet.name => subnet.id
  }
}

output "nsg_id" {
  description = "ID of the default network security group"
  value       = azurerm_network_security_group.default.id
}

output "bastion_host_id" {
  description = "ID of the Bastion host"
  value       = azurerm_bastion_host.main.id
}

output "ai_services_vnet_id" {
  description = "ID of the AI Services VNet"
  value       = azurerm_virtual_network.ai_services.id
}

output "ai_services_private_endpoints_subnet_id" {
  description = "ID of the private endpoints subnet in the AI Services VNet"
  value       = azurerm_subnet.ai_services_subnets["PrivateEndpointsSubnet"].id
}

output "ml_services_subnet_ids" {
  description = "Map of ML services subnet names to IDs"
  value = {
    for subnet in azurerm_subnet.ml_services_subnets : subnet.name => subnet.id
  }
}

output "data_services_subnet_ids" {
  description = "Map of data services subnet names to IDs"
  value = {
    for subnet in azurerm_subnet.data_services_subnets : subnet.name => subnet.id
  }
}

output "analytics_subnet_ids" {
  description = "Map of analytics subnet names to IDs"
  value = {
    for subnet in azurerm_subnet.analytics_subnets : subnet.name => subnet.id
  }
}
