output "key_vault" {
  value       = local.az.key_vault
  description = "Naming conventions for Key Vault resources"
}

output "key_vault_key" {
  value       = local.az.key_vault_key
  description = "Naming conventions for Key Vault Key resources"
}

output "key_vault_secret" {
  value       = local.az.key_vault_secret
  description = "Naming conventions for Key Vault Secret resources"
}

output "key_vault_certificate" {
  value       = local.az.key_vault_certificate
  description = "Naming conventions for Key Vault Certificate resources"
}

output "disk_encryption_set" {
  value       = local.az.disk_encryption_set
  description = "Naming conventions for Disk Encryption Set resources"
}

output "application_security_group" {
  value       = local.az.application_security_group
  description = "Naming conventions for Application Security Group resources"
}