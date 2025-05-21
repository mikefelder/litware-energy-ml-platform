provider "azurerm" {
  features {}
}

provider "azuread" {
  # Needed for managing Entra ID users and groups
}

variable "location" {
  default = "eastus"
}

variable "tenant_domain" {
  description = "The domain name of the Entra ID tenant"
  type        = string
  default     = "litwareenergyco.onmicrosoft.com"
}

variable "tags" {
  default = {
    Project     = "AIML-Energy"
    Environment = "POC"
    Company     = "Litware Energy Co"
    Owner       = "AnalyticsTeam"
    CostCenter  = "EnergyPOC"
  }
}

variable "admin_group_object_id" {
  description = "Object ID of the Azure AD group to assign Contributor access"
  type        = string
}

data "azurerm_client_config" "current" {}

# Naming convention module (assumes use of Azure Naming module if available)
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.0"
  suffix  = ["litware", "poc"]
}

# Create Azure AD Group
resource "azuread_group" "ml_team" {
  display_name     = "Litware-AIML-Team"
  security_enabled = true
}

# Create test users and add to group
resource "random_password" "user_passwords" {
  count           = 3
  length          = 16
  special         = true
  override_characters = "!@#%&*"
}

resource "azuread_user" "ml_users" {
  count                = 3
  user_principal_name  = "mluser${count.index + 1}@${var.tenant_domain}"
  display_name         = "ML User ${count.index + 1}"
  mail_nickname        = "mluser${count.index + 1}"
  password             = random_password.user_passwords[count.index].result
  force_password_change = true
}

resource "azuread_group_member" "ml_team_members" {
  count            = 3
  group_object_id  = azuread_group.ml_team.id
  member_object_id = azuread_user.ml_users[count.index].id
}

output "ml_users_credentials" {
  value = {
    for i in range(3) :
    "mluser${i + 1}@${var.tenant_domain}" => random_password.user_passwords[i].result
  }
  sensitive   = true
  description = "Initial credentials for POC ML users."
}

# RBAC: Assign Contributor role to admin group
resource "azurerm_role_assignment" "admin_contributor" {
  for_each             = {
    for rg in [
      azurerm_resource_group.ai_ml_foundation,
      azurerm_resource_group.vignette_predictive_maintenance,
      azurerm_resource_group.vignette_emissions_tracking,
      azurerm_resource_group.vignette_genai_fieldops,
      azurerm_resource_group.vignette_trading_analytics
    ] : rg.name => rg
  }
  scope                = each.value.id
  role_definition_name = "Contributor"
  principal_id         = var.admin_group_object_id
}

# Assign Owner role to current user
resource "azurerm_role_assignment" "owner_current_user" {
  for_each             = {
    for rg in [
      azurerm_resource_group.ai_ml_foundation,
      azurerm_resource_group.vignette_predictive_maintenance,
      azurerm_resource_group.vignette_emissions_tracking,
      azurerm_resource_group.vignette_genai_fieldops,
      azurerm_resource_group.vignette_trading_analytics
    ] : rg.name => rg
  }
  scope                = each.value.id
  role_definition_name = "Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Assign roles for storage account and ML workspace
resource "azurerm_role_assignment" "ml_workspace_admin_group" {
  scope                = azurerm_machine_learning_workspace.ml.id
  role_definition_name = "Contributor"
  principal_id         = var.admin_group_object_id
}

resource "azurerm_role_assignment" "ml_workspace_owner_user" {
  scope                = azurerm_machine_learning_workspace.ml.id
  role_definition_name = "Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "storage_admin_group" {
  scope                = azurerm_storage_account.ml.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.admin_group_object_id
}

resource "azurerm_role_assignment" "storage_owner_user" {
  scope                = azurerm_storage_account.ml.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Placeholder for Data Factory and Power BI integration (manual or ARM template required)
# Future additions can include azurerm_data_factory and Power BI embedded resources
