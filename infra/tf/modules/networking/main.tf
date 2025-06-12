# Core networking infrastructure

# Hub Virtual Network
resource "azurerm_virtual_network" "hub" {
  name                = "vnet-${var.prefix}-hub-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.hub_address_space
  tags                = var.tags
}

# Create subnets
resource "azurerm_subnet" "hub_subnets" {
  for_each             = { for subnet in var.hub_subnets : subnet.name => subnet }
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [each.value.address_prefix]

  service_endpoints = each.value.name == "SharedServicesSubnet" ? [
    "Microsoft.Storage",
    "Microsoft.KeyVault",
    "Microsoft.ServiceBus",
    "Microsoft.EventHub"
  ] : []
}

# Network Security Groups
resource "azurerm_network_security_group" "default" {
  name                = "nsg-${var.prefix}-default-${var.environment}"
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
