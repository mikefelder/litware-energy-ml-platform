# Hub VNet
resource "azurerm_virtual_network" "hub" {
  name                = "${var.prefix}-hub-vnet-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.hub_vnet_address_space]
  tags                = var.tags
}

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

# ML Services VNet
resource "azurerm_virtual_network" "ml_services" {
  name                = "${var.prefix}-ml-vnet-${var.environment}"
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

# Data Services VNet
resource "azurerm_virtual_network" "data_services" {
  name                = "${var.prefix}-data-vnet-${var.environment}"
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

# Analytics VNet
resource "azurerm_virtual_network" "analytics" {
  name                = "${var.prefix}-analytics-vnet-${var.environment}"
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

# VNet Peering: Hub to Spokes
resource "azurerm_virtual_network_peering" "hub_to_ml" {
  name                      = "hub-to-ml"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.ml_services.id

  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
  allow_gateway_transit       = true
}

resource "azurerm_virtual_network_peering" "hub_to_data" {
  name                      = "hub-to-data"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.data_services.id

  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
  allow_gateway_transit       = true
}

resource "azurerm_virtual_network_peering" "hub_to_analytics" {
  name                      = "hub-to-analytics"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.analytics.id

  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
  allow_gateway_transit       = true
}

# VNet Peering: Spokes to Hub
resource "azurerm_virtual_network_peering" "ml_to_hub" {
  name                      = "ml-to-hub"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.ml_services.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id

  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
  use_remote_gateways         = true
}

resource "azurerm_virtual_network_peering" "data_to_hub" {
  name                      = "data-to-hub"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.data_services.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id

  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
  use_remote_gateways         = true
}

resource "azurerm_virtual_network_peering" "analytics_to_hub" {
  name                      = "analytics-to-hub"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.analytics.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id

  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
  use_remote_gateways         = true
}

# Network Security Groups
resource "azurerm_network_security_group" "shared_services" {
  name                = "${var.prefix}-shared-services-nsg-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "ml_compute" {
  name                = "${var.prefix}-ml-compute-nsg-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "ml_services" {
  name                = "${var.prefix}-ml-services-nsg-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "data_storage" {
  name                = "${var.prefix}-data-storage-nsg-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "database" {
  name                = "${var.prefix}-database-nsg-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "analytics_services" {
  name                = "${var.prefix}-analytics-services-nsg-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "data_factory" {
  name                = "${var.prefix}-data-factory-nsg-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
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
