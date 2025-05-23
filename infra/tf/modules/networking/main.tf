# Core networking infrastructure

# Hub Virtual Network
resource "azurerm_virtual_network" "hub" {
  name                = "vnet-${var.prefix}-hub-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.hub_vnet_address_space]
  tags                = var.tags
}

# Hub Subnets
resource "azurerm_subnet" "bastion" {
  name                = "AzureBastionSubnet" # Required name for Bastion
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub_bastion_subnet_address_prefix]
}

resource "azurerm_subnet" "gateway" {
  name                = "GatewaySubnet" # Required name for Gateway
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub_gateway_subnet_address_prefix]
}

resource "azurerm_subnet" "shared_services" {
  name                = "SharedServicesSubnet"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub_shared_services_subnet_address_prefix]

  service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.Storage",
    "Microsoft.Sql"
  ]
}

# Network Security Groups
resource "azurerm_network_security_group" "default" {
  name                = "nsg-${var.prefix}-default-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "shared_services" {
  name                = "nsg-${var.prefix}-shared-services-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Azure Bastion
resource "azurerm_public_ip" "bastion" {
  name                = "pip-${var.prefix}-bastion-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_bastion_host" "main" {
  name                = "bas-${var.prefix}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.hub_subnets["AzureBastionSubnet"].id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}

# ML Services Virtual Network
resource "azurerm_virtual_network" "ml_services" {
  name                = "vnet-${var.prefix}-mlservices-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.ml_services_address_space
  tags                = var.tags
}

# ML Services Subnets
resource "azurerm_subnet" "ml_services_subnets" {
  for_each             = { for subnet in var.ml_services_subnets : subnet.name => subnet }
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.ml_services.name
  address_prefixes     = [each.value.address_prefix]

  # Service endpoints for AKS and ML services subnets
  service_endpoints = contains(["AksSystemNodesSubnet", "AksUserNodesSubnet", "MlServicesSubnet"], each.value.name) ? [
    "Microsoft.Storage",
    "Microsoft.KeyVault",
    "Microsoft.ContainerRegistry",
    "Microsoft.AzureActiveDirectory"
  ] : []
}

# ML Services VNet
resource "azurerm_virtual_network" "ml_services" {
  name                = "vnet-${var.prefix}-ml-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.ml_services_vnet_address_space]
  tags                = var.tags
}

resource "azurerm_subnet" "ml_compute" {
  name                 = "MLComputeSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.ml_services.name
  address_prefixes     = [var.ml_compute_subnet_address_prefix]

  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.KeyVault",
    "Microsoft.ContainerRegistry"
  ]
}

resource "azurerm_subnet" "ml_services" {
  name                 = "MLServicesSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.ml_services.name
  address_prefixes     = [var.ml_services_subnet_address_prefix]

  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.KeyVault",
    "Microsoft.ContainerRegistry"
  ]
}

resource "azurerm_subnet" "ml_private_endpoint" {
  name                 = "MLPrivateEndpointSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.ml_services.name
  address_prefixes     = [var.ml_private_endpoint_subnet_address_prefix]

  private_endpoint_network_policies_enabled = true
}

resource "azurerm_network_security_group" "ml_compute" {
  name                = "nsg-${var.prefix}-ml-compute-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "ml_services" {
  name                = "nsg-${var.prefix}-ml-services-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Data Services Virtual Network
resource "azurerm_virtual_network" "data_services" {
  name                = "vnet-${var.prefix}-dataservices-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.data_services_address_space
  tags                = var.tags
}

# Data Services Subnets
resource "azurerm_subnet" "data_services_subnets" {
  for_each             = { for subnet in var.data_services_subnets : subnet.name => subnet }
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.data_services.name
  address_prefixes     = [each.value.address_prefix]

  # Service endpoints for data services subnets
  service_endpoints = contains(["DatabaseSubnet", "RedisSubnet", "StorageSubnet"], each.value.name) ? [
    "Microsoft.Storage",
    "Microsoft.KeyVault",
    "Microsoft.Sql",
    "Microsoft.AzureActiveDirectory"
  ] : []
}

# Data Services VNet
resource "azurerm_virtual_network" "data_services" {
  name                = "vnet-${var.prefix}-data-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.data_services_vnet_address_space]
  tags                = var.tags
}

resource "azurerm_subnet" "data_storage" {
  name                 = "DataStorageSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.data_services.name
  address_prefixes     = [var.data_storage_subnet_address_prefix]

  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.KeyVault"
  ]
}

resource "azurerm_subnet" "database" {
  name                 = "DatabaseSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.data_services.name
  address_prefixes     = [var.database_subnet_address_prefix]

  service_endpoints = [
    "Microsoft.Sql",
    "Microsoft.KeyVault"
  ]
}

resource "azurerm_subnet" "data_private_endpoint" {
  name                 = "DataPrivateEndpointSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.data_services.name
  address_prefixes     = [var.data_private_endpoint_subnet_address_prefix]

  private_endpoint_network_policies_enabled = true
}

resource "azurerm_network_security_group" "data_storage" {
  name                = "nsg-${var.prefix}-data-storage-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "database" {
  name                = "nsg-${var.prefix}-database-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Analytics Virtual Network
resource "azurerm_virtual_network" "analytics" {
  name                = "vnet-${var.prefix}-analytics-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.analytics_address_space
  tags                = var.tags
}

# Analytics Subnets
resource "azurerm_subnet" "analytics_subnets" {
  for_each             = { for subnet in var.analytics_subnets : subnet.name => subnet }
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.analytics.name
  address_prefixes     = [each.value.address_prefix]

  # Service endpoints for analytics subnets
  service_endpoints = contains(["AnalyticsSubnet", "DataLakeSubnet", "MonitoringSubnet"], each.value.name) ? [
    "Microsoft.Storage",
    "Microsoft.KeyVault",
    "Microsoft.EventHub",
    "Microsoft.Sql",
    "Microsoft.AzureActiveDirectory"
  ] : []
}

# Analytics VNet
resource "azurerm_virtual_network" "analytics" {
  name                = "vnet-${var.prefix}-analytics-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.analytics_vnet_address_space]
  tags                = var.tags
}

resource "azurerm_subnet" "analytics_services" {
  name                 = "AnalyticsServicesSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.analytics.name
  address_prefixes     = [var.analytics_services_subnet_address_prefix]

  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.KeyVault"
  ]
}

resource "azurerm_subnet" "data_factory" {
  name                 = "DataFactorySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.analytics.name
  address_prefixes     = [var.data_factory_subnet_address_prefix]

  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.KeyVault",
    "Microsoft.EventHub"
  ]
}

resource "azurerm_subnet" "analytics_private_endpoint" {
  name                 = "AnalyticsPrivateEndpointSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.analytics.name
  address_prefixes     = [var.analytics_private_endpoint_subnet_address_prefix]

  private_endpoint_network_policies_enabled = true
}

resource "azurerm_network_security_group" "analytics_services" {
  name                = "nsg-${var.prefix}-analytics-services-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "data_factory" {
  name                = "nsg-${var.prefix}-data-factory-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# VNet Peering: Hub to Spokes
resource "azurerm_virtual_network_peering" "hub_to_ml" {
  name                      = "vnet-peer-hub-to-ml"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.ml_services.id

  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
  allow_gateway_transit       = true
}

resource "azurerm_virtual_network_peering" "hub_to_data" {
  name                      = "vnet-peer-hub-to-data"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.data_services.id

  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
  allow_gateway_transit       = true
}

resource "azurerm_virtual_network_peering" "hub_to_analytics" {
  name                      = "vnet-peer-hub-to-analytics"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.analytics.id

  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
  allow_gateway_transit       = true
}

# VNet Peering: Spokes to Hub
resource "azurerm_virtual_network_peering" "ml_to_hub" {
  name                      = "vnet-peer-ml-to-hub"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.ml_services.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id

  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
  use_remote_gateways         = true
}

resource "azurerm_virtual_network_peering" "data_to_hub" {
  name                      = "vnet-peer-data-to-hub"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.data_services.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id

  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
  use_remote_gateways         = true
}

resource "azurerm_virtual_network_peering" "analytics_to_hub" {
  name                      = "vnet-peer-analytics-to-hub"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.analytics.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id

  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
  use_remote_gateways         = true
}

# NSG Associations
resource "azurerm_subnet_network_security_group_association" "shared_services" {
  subnet_id                 = azurerm_subnet.shared_services.id
  network_security_group_id = azurerm_network_security_group.shared_services.id
}

resource "azurerm_subnet_network_security_group_association" "ml_compute" {
  subnet_id                 = azurerm_subnet.ml_compute.id
  network_security_group_id = azurerm_network_security_group.ml_compute.id
}

resource "azurerm_subnet_network_security_group_association" "ml_services" {
  subnet_id                 = azurerm_subnet.ml_services.id
  network_security_group_id = azurerm_network_security_group.ml_services.id
}

resource "azurerm_subnet_network_security_group_association" "data_storage" {
  subnet_id                 = azurerm_subnet.data_storage.id
  network_security_group_id = azurerm_network_security_group.data_storage.id
}

resource "azurerm_subnet_network_security_group_association" "database" {
  subnet_id                 = azurerm_subnet.database.id
  network_security_group_id = azurerm_network_security_group.database.id
}

resource "azurerm_subnet_network_security_group_association" "analytics_services" {
  subnet_id                 = azurerm_subnet.analytics_services.id
  network_security_group_id = azurerm_network_security_group.analytics_services.id
}

resource "azurerm_subnet_network_security_group_association" "data_factory" {
  subnet_id                 = azurerm_subnet.data_factory.id
  network_security_group_id = azurerm_network_security_group.data_factory.id
}

# AI Services Virtual Network
resource "azurerm_virtual_network" "ai_services" {
  name                = "vnet-${var.prefix}-aiservices-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.ai_services_address_space
  tags                = var.tags
}

# AI Services Subnets
resource "azurerm_subnet" "ai_services_subnets" {
  for_each             = { for subnet in var.ai_services_subnets : subnet.name => subnet }
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.ai_services.name
  address_prefixes     = [each.value.address_prefix]

  # Service endpoints for AI services subnets
  service_endpoints = contains(["AiServicesSubnet", "DocumentIntelligenceSubnet", "OpenAISubnet", "SearchSubnet", "StorageSubnet"], each.value.name) ? [
    "Microsoft.Storage",
    "Microsoft.KeyVault",
    "Microsoft.CognitiveServices",
    "Microsoft.AzureActiveDirectory"
  ] : []
  # Private endpoint network policies
  private_endpoint_network_policies = each.value.name == "PrivateEndpointsSubnet" ? "Disabled" : "Enabled"
}
