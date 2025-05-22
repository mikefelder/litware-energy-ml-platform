output "ml_team_group_id" {
  description = "Object ID of the ML team group"
  value       = azuread_group.ml_team.object_id
}

output "ml_users_credentials" {
  description = "Initial credentials for POC ML users"
  value = {
    for i in range(var.user_count) :
    "mluser${i + 1}@${var.tenant_domain}" => random_password.user_passwords[i].result
  }
  sensitive = true
}