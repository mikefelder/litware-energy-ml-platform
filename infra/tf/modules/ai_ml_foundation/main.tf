# AI/ML Foundation Module
# This module sets up core AI/ML infrastructure components

resource "azurerm_machine_learning_workspace" "mlw" {
  name                          = "${var.prefix}-mlw-${var.environment}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  application_insights_id       = var.application_insights_id
  key_vault_id                  = var.key_vault_id
  storage_account_id            = azurerm_storage_account.mlstorage.id
  container_registry_id         = azurerm_container_registry.mlacr.id
  public_network_access_enabled = false

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_storage_account" "mlstorage" {
  name                            = "${var.prefix}mlst${var.environment}"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  is_hns_enabled                  = false
  min_tls_version                = "TLS1_2"
  shared_access_key_enabled       = false
  default_to_oauth_authentication = true
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false

  identity {
    type = "SystemAssigned"
  }

  network_rules {
    default_action             = "Deny"
    ip_rules                   = []
    virtual_network_subnet_ids = [var.subnet_id]
    bypass                     = ["AzureServices"]
  }

  tags = var.tags
}

resource "azurerm_container_registry" "mlacr" {
  name                          = "${var.prefix}mlacr${var.environment}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = "Premium"
  admin_enabled                 = false
  public_network_access_enabled = false

  tags = var.tags
}

# Azure Machine Learning Compute Cluster
resource "azurerm_machine_learning_compute_cluster" "compute" {
  name                          = "cpu-cluster"
  location                      = var.location
  vm_priority                   = "Dedicated"
  vm_size                       = "Standard_DS3_v2"
  machine_learning_workspace_id = azurerm_machine_learning_workspace.mlw.id
  subnet_resource_id           = var.subnet_id

  scale_settings {
    min_node_count                       = 0
    max_node_count                       = 4
    scale_down_nodes_after_idle_duration = "PT30M" # 30 minutes
  }

  identity {
    type = "SystemAssigned"
  }
}

# Storage Account Private Endpoints
resource "azurerm_private_endpoint" "mlstorage_blob" {
  name                = "pe-${azurerm_storage_account.mlstorage.name}-blob"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-${azurerm_storage_account.mlstorage.name}-blob"
    private_connection_resource_id = azurerm_storage_account.mlstorage.id
    is_manual_connection          = false
    subresource_names            = ["blob"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [var.private_dns_zone_ids["blob"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "mlstorage_file" {
  name                = "pe-${azurerm_storage_account.mlstorage.name}-file"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-${azurerm_storage_account.mlstorage.name}-file"
    private_connection_resource_id = azurerm_storage_account.mlstorage.id
    is_manual_connection          = false
    subresource_names            = ["file"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [var.private_dns_zone_ids["file"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "mlstorage_queue" {
  name                = "pe-${azurerm_storage_account.mlstorage.name}-queue"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-${azurerm_storage_account.mlstorage.name}-queue"
    private_connection_resource_id = azurerm_storage_account.mlstorage.id
    is_manual_connection          = false
    subresource_names            = ["queue"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [var.private_dns_zone_ids["queue"]]
  }

  tags = var.tags
}
