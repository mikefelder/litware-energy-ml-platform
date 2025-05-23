# Storage module - manages Azure Storage resources

# Common naming module for consistent naming
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.0"
  suffix  = var.naming_module_suffix
}

# ML Storage Account
resource "azurerm_storage_account" "ml" {
  name                      = "${var.prefix}mlstg${var.environment}"
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
    is_hns_enabled                    = false
  min_tls_version                   = "TLS1_2"
  shared_access_key_enabled         = false
  default_to_oauth_authentication   = true
  public_network_access_enabled     = false
  allow_nested_items_to_be_public  = false

  identity {
    type = "SystemAssigned"
  }

  network_rules {
    default_action             = "Deny"
    ip_rules                   = []
    bypass                     = ["AzureServices"]
    virtual_network_subnet_ids = var.subnet_ids
  }

  tags = var.tags
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

# Private Endpoints
resource "azurerm_private_endpoint" "ml_blob" {
  name                = "pe-${azurerm_storage_account.ml.name}-blob"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-${azurerm_storage_account.ml.name}-blob"
    private_connection_resource_id = azurerm_storage_account.ml.id
    is_manual_connection          = false
    subresource_names            = ["blob"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [var.private_dns_zone_ids["blob"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "ml_file" {
  name                = "pe-${azurerm_storage_account.ml.name}-file"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-${azurerm_storage_account.ml.name}-file"
    private_connection_resource_id = azurerm_storage_account.ml.id
    is_manual_connection          = false
    subresource_names            = ["file"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [var.private_dns_zone_ids["file"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "ml_queue" {
  name                = "pe-${azurerm_storage_account.ml.name}-queue"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-${azurerm_storage_account.ml.name}-queue"
    private_connection_resource_id = azurerm_storage_account.ml.id
    is_manual_connection          = false
    subresource_names            = ["queue"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [var.private_dns_zone_ids["queue"]]
  }

  tags = var.tags
}
