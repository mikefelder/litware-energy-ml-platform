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
