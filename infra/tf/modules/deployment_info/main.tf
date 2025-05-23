# Module for consolidating all deployment information and outputs
variable "ml_users_credentials" {
  description = "Initial credentials for POC ML users"
  type        = any
  sensitive   = true
}

variable "resource_group_ids" {
  description = "Map of resource group IDs"
  type        = map(string)
}

variable "private_dns_zone_ids" {
  description = "Map of private DNS zone IDs"
  type        = map(string)
}

# Deployment outputs
output "ml_users_credentials" {
  value       = var.ml_users_credentials
  sensitive   = true
  description = "Initial credentials for POC ML users"
}

output "resource_group_ids" {
  value       = var.resource_group_ids
  description = "Map of resource group IDs"
}

output "private_dns_zone_ids" {
  value       = var.private_dns_zone_ids
  description = "Map of private DNS zone IDs"
}
