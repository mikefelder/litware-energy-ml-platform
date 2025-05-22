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
  name                     = "${var.prefix}mlst${var.environment}"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "GRS"
  is_hns_enabled          = false

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
