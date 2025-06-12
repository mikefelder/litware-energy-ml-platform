output "unique-seed" {
  value = local.random_safe_generation
}

output "validation" {
  value = local.validation
}

output "virtual_machine" {
  value       = local.az.virtual_machine
  description = "Naming convention for virtual machines"
}

output "virtual_network" {
  value       = local.az.virtual_network
  description = "Naming convention for virtual networks"
}

output "subnet" {
  value       = local.az.subnet
  description = "Naming convention for subnets"
}

output "network_security_group" {
  value       = local.az.network_security_group
  description = "Naming convention for network security groups"
}

output "public_ip" {
  value       = local.az.public_ip
  description = "Naming convention for public IPs"
}

output "storage_account" {
  value       = local.az.storage_account
  description = "Naming convention for storage accounts"
}

output "log_analytics_workspace" {
  value       = local.az.log_analytics_workspace
  description = "Naming convention for Log Analytics workspaces"
}

output "monitor_action_group" {
  value       = local.az.monitor_action_group
  description = "Naming convention for Monitor Action Groups"
}

output "fabric_capacity" {
  value       = local.az.fabric_capacity
  description = "Naming convention for Fabric capacities"
}

output "key_vault" {
  value       = local.az.key_vault
  description = "Naming convention for Key Vaults"
}

output "application_insights" {
  value = module.analytics.naming_rules.application_insights
  description = "Naming convention for Application Insights"
}


