# Identity module - manages Azure AD resources

# Data sources
data "azurerm_client_config" "current" {}

# Create Azure AD Groups
resource "azuread_group" "ml_team" {
  display_name     = var.team_group_name
  security_enabled = true
}

resource "azuread_group" "network_admins" {
  display_name     = "${var.team_group_name}-network-admins"
  security_enabled = true
  description      = "Network administrators with private endpoint management permissions"
}

locals {
  # Extract clean UUID by removing all non-UUID characters
  network_admins_group_id = regex("[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}", azuread_group.network_admins.id)
}

# Add the current user to the network admins group
resource "azuread_group_member" "current_user_network_admin" {
  group_object_id  = local.network_admins_group_id
  member_object_id = data.azurerm_client_config.current.object_id
}

# Create test users and add to group
resource "random_password" "user_passwords" {
  count            = var.user_count
  length           = 16
  special          = true
  override_special = "!@#%&*"
}

resource "azuread_user" "ml_users" {
  count                 = var.user_count
  user_principal_name   = "mluser${count.index + 1}@${var.tenant_domain}"
  display_name          = "ML User ${count.index + 1}"
  mail_nickname         = "mluser${count.index + 1}"
  password              = random_password.user_passwords[count.index].result
  force_password_change = true
}

resource "azuread_group_member" "ml_team_members" {
  count            = var.user_count
  group_object_id  = azuread_group.ml_team.object_id
  member_object_id = azuread_user.ml_users[count.index].object_id
}
