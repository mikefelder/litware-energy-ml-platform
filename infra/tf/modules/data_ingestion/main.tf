# Common naming module for consistent naming
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.0"
  suffix  = [var.environment]
}

# Data Ingestion Infrastructure

# Event Hub Namespace
resource "azurerm_eventhub_namespace" "main" {
  name                = module.naming.eventhub_namespace.name
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
  name                            = module.naming.storage_account.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  is_hns_enabled                  = true
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

# Data Lake Storage Private Endpoints
resource "azurerm_private_endpoint" "datalake_blob" {
  name                = "pe-${azurerm_storage_account.datalake.name}-blob"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-${azurerm_storage_account.datalake.name}-blob"
    private_connection_resource_id = azurerm_storage_account.datalake.id
    is_manual_connection          = false
    subresource_names            = ["blob"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [var.private_dns_zone_ids["blob"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "datalake_dfs" {
  name                = "pe-${azurerm_storage_account.datalake.name}-dfs"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-${azurerm_storage_account.datalake.name}-dfs"
    private_connection_resource_id = azurerm_storage_account.datalake.id
    is_manual_connection          = false
    subresource_names            = ["dfs"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [var.private_dns_zone_ids["dfs"]]
  }

  tags = var.tags
}

# Service Bus Namespace
resource "azurerm_servicebus_namespace" "main" {
  name                = module.naming.servicebus_namespace.name
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
  name                   = module.naming.data_factory.name
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
