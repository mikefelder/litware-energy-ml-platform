output "tenant_id" {
  value       = data.azurerm_client_config.current.tenant_id
  description = "The Azure tenant ID"
}

output "current_user_object_id" {
  value       = data.azurerm_client_config.current.object_id
  description = "The current user's object ID"
}

output "ml_team_group_id" {
  description = "Object ID of the ML team group"
  value       = azuread_group.ml_team.object_id
}

output "network_admins_group_id" {
  description = "Object ID of the network administrators group"
  value       = azuread_group.network_admins.object_id
}

output "ml_users_credentials" {
  description = "Initial credentials for POC ML users"
  value = {
    for i in range(var.user_count) :
    "mluser${i + 1}@${var.tenant_domain}" => random_password.user_passwords[i].result
  }
  sensitive = true
}