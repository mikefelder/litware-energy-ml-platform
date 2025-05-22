# Data Ingestion Infrastructure

# Event Hub Namespace
resource "azurerm_eventhub_namespace" "main" {
  name                = "evhns-${var.prefix}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  capacity            = 2

  public_network_access_enabled = false
  minimum_tls_version           = "1.2"

  tags = var.tags
}

# Event Hub for sensor data
resource "azurerm_eventhub" "sensor_data" {
  name              = "sensor-data"
  namespace_id      = azurerm_eventhub_namespace.main.id
  partition_count   = 8
  message_retention = 7
}

# Data Lake Storage Gen2
resource "azurerm_storage_account" "datalake" {
  name                     = "${var.prefix}dls${var.environment}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  is_hns_enabled           = true

  network_rules {
    default_action             = "Deny"
    ip_rules                   = []
    virtual_network_subnet_ids = [var.subnet_id]
    bypass                     = ["AzureServices"]
  }

  tags = var.tags
}

# Service Bus Namespace
resource "azurerm_servicebus_namespace" "main" {
  name                = "sb-${var.prefix}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Premium"
  capacity            = 1
  tags               = var.tags

  premium_messaging_partitions = 1
  public_network_access_enabled = false
  minimum_tls_version = "1.2"
  local_auth_enabled = true
}

# Data Factory
resource "azurerm_data_factory" "main" {
  name                   = "adf-${var.prefix}-${var.environment}"
  location               = var.location
  resource_group_name    = var.resource_group_name
  public_network_enabled = false

  identity {
    type = "SystemAssigned"
  }

  vsts_configuration {
    account_name    = var.devops_project
    branch_name     = "main"
    project_name    = var.devops_project
    repository_name = "data-pipelines"
    root_folder     = "/"
    tenant_id       = var.tenant_id
  }

  tags = var.tags
}

# Grant Data Factory MSI access to Data Lake
resource "azurerm_role_assignment" "adf_datalake" {
  scope                = azurerm_storage_account.datalake.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.main.identity[0].principal_id
}

# Grant Data Factory MSI access to Event Hub
resource "azurerm_role_assignment" "adf_eventhub" {
  scope                = azurerm_eventhub_namespace.main.id
  role_definition_name = "Azure Event Hubs Data Receiver"
  principal_id         = azurerm_data_factory.main.identity[0].principal_id
}
