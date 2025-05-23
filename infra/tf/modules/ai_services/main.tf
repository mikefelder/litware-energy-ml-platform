# Document Intelligence Service
resource "azurerm_cognitive_account" "document_intelligence" {
  name                          = "doci-${var.prefix}-${var.environment}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  kind                         = "FormRecognizer"
  sku_name                     = "S0"
  tags                         = var.tags
  public_network_access_enabled = false
  custom_subdomain_name        = "doci-${var.prefix}-${var.environment}"

  network_acls {
    default_action             = "Deny"
    ip_rules                  = []
  }
}

# Azure OpenAI Service
resource "azurerm_cognitive_account" "openai" {
  name                          = "oai-${var.prefix}-${var.environment}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  kind                         = "OpenAI"
  sku_name                     = "S0"
  tags                         = var.tags
  public_network_access_enabled = false
  custom_subdomain_name        = "oai-${var.prefix}-${var.environment}"

  network_acls {
    default_action             = "Deny"
    ip_rules                  = []
  }
}

# Azure AI Search Service
resource "azurerm_search_service" "search" {
  name                          = "srch-${var.prefix}-${var.environment}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                         = "standard"
  partition_count             = 1
  replica_count               = 1
  tags                        = var.tags
  public_network_access_enabled = false
}

# Storage Account for AI Services
resource "azurerm_storage_account" "ai_storage" {
  name                            = "stlitwareai${var.environment}"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
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
    bypass                     = ["AzureServices"]
    virtual_network_subnet_ids = [var.subnet_id]
  }

  tags = var.tags
}

# Azure Machine Learning Service
resource "azurerm_cognitive_account" "machine_learning" {
  name                          = "aml-${var.prefix}-${var.environment}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  kind                         = "CognitiveServices"
  sku_name                     = "S0"
  tags                         = var.tags
  public_network_access_enabled = false
  custom_subdomain_name        = "aml-${var.prefix}-${var.environment}"

  network_acls {
    default_action             = "Deny"
    ip_rules                  = []
  }
}

# Private Endpoints
resource "azurerm_private_endpoint" "document_intelligence" {
  name                = "pe-${azurerm_cognitive_account.document_intelligence.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags               = var.tags

  private_service_connection {
    name                           = "psc-${azurerm_cognitive_account.document_intelligence.name}"
    private_connection_resource_id = azurerm_cognitive_account.document_intelligence.id
    subresource_names             = ["account"]
    is_manual_connection          = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_ids["cognitive_services"]]
  }
}

resource "azurerm_private_endpoint" "openai" {
  name                = "pe-${azurerm_cognitive_account.openai.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags               = var.tags

  private_service_connection {
    name                           = "psc-${azurerm_cognitive_account.openai.name}"
    private_connection_resource_id = azurerm_cognitive_account.openai.id
    subresource_names             = ["account"]
    is_manual_connection          = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_ids["cognitive_services"]]
  }
}

resource "azurerm_private_endpoint" "search" {
  name                = "pe-${azurerm_search_service.search.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags               = var.tags

  private_service_connection {
    name                           = "psc-${azurerm_search_service.search.name}"
    private_connection_resource_id = azurerm_search_service.search.id
    subresource_names             = ["searchService"]
    is_manual_connection          = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_ids["search"]]
  }
}

# Storage Account Private Endpoints
resource "azurerm_private_endpoint" "ai_storage_blob" {
  name                = "pe-${azurerm_storage_account.ai_storage.name}-blob"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-${azurerm_storage_account.ai_storage.name}-blob"
    private_connection_resource_id = azurerm_storage_account.ai_storage.id
    is_manual_connection          = false
    subresource_names            = ["blob"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [var.private_dns_zone_ids["blob"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "ai_storage_table" {
  name                = "pe-${azurerm_storage_account.ai_storage.name}-table"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-${azurerm_storage_account.ai_storage.name}-table"
    private_connection_resource_id = azurerm_storage_account.ai_storage.id
    is_manual_connection          = false
    subresource_names            = ["table"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [var.private_dns_zone_ids["table"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "ai_storage_file" {
  name                = "pe-${azurerm_storage_account.ai_storage.name}-file"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-${azurerm_storage_account.ai_storage.name}-file"
    private_connection_resource_id = azurerm_storage_account.ai_storage.id
    is_manual_connection          = false
    subresource_names            = ["file"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [var.private_dns_zone_ids["file"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "machine_learning" {
  name                = "pe-${azurerm_cognitive_account.machine_learning.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags               = var.tags

  private_service_connection {
    name                           = "psc-${azurerm_cognitive_account.machine_learning.name}"
    private_connection_resource_id = azurerm_cognitive_account.machine_learning.id
    subresource_names             = ["account"]
    is_manual_connection          = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_ids["cognitive_services"]]
  }
}

# GPT-4 Model Deployment
resource "azurerm_cognitive_deployment" "gpt4" {
  cognitive_account_id    = azurerm_cognitive_account.openai.id
  name                   = "gpt-4"
  version_upgrade_option = "OnceNewDefaultVersionAvailable"

  model {
    format  = "OpenAI"
    name    = "gpt-4"
  }

  sku {
    name     = "Standard"
    capacity = 10
  }
}

# Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "document_intelligence" {
  name                       = "diag-${azurerm_cognitive_account.document_intelligence.name}"
  target_resource_id         = azurerm_cognitive_account.document_intelligence.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "audit"
  }

  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "openai" {
  name                       = "diag-${azurerm_cognitive_account.openai.name}"
  target_resource_id         = azurerm_cognitive_account.openai.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "audit"
  }

  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "search" {
  name                       = "diag-${azurerm_search_service.search.name}"
  target_resource_id         = azurerm_search_service.search.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "machine_learning" {
  name                       = "diag-${azurerm_cognitive_account.machine_learning.name}"
  target_resource_id         = azurerm_cognitive_account.machine_learning.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "audit"
  }

  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
  }
}
