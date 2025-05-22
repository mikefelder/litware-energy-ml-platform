# Storage module - manages Azure Storage resources

# Common naming module for consistent naming
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.0"
  suffix  = var.naming_module_suffix
}

# ML Storage Account
resource "azurerm_storage_account" "ml" {
  name                     = "${var.prefix}mlstg${var.environment}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

resource "azurerm_storage_container" "datasets" {
  name                  = "datasets"
  storage_account_id    = azurerm_storage_account.ml.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "models" {
  name                  = "models"
  storage_account_id    = azurerm_storage_account.ml.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "notebooks" {
  name                  = "notebooks"
  storage_account_id    = azurerm_storage_account.ml.id
  container_access_type = "private"
}
