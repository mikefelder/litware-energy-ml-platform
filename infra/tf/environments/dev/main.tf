# Dev Environment Configuration

provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../../modules/resource_group"

  prefix      = var.prefix
  environment = "dev"
  location    = var.location
  tags        = var.tags
}

module "networking" {
  source = "../../modules/networking"

  prefix             = var.prefix
  environment        = "dev"
  location          = var.location
  resource_group_name = module.resource_group.name
  tags              = var.tags

  # Hub Network Configuration
  hub_vnet_address_space = "10.0.0.0/16"
  hub_bastion_subnet_address_prefix = "10.0.1.0/24"
  hub_gateway_subnet_address_prefix = "10.0.2.0/24"
  hub_shared_services_subnet_address_prefix = "10.0.3.0/24"

  # ML Services Network Configuration
  ml_services_vnet_address_space = "10.1.0.0/16"
  ml_compute_subnet_address_prefix = "10.1.1.0/24"
  ml_services_subnet_address_prefix = "10.1.2.0/24"
  ml_private_endpoint_subnet_address_prefix = "10.1.3.0/24"

  # Data Services Network Configuration
  data_services_vnet_address_space = "10.2.0.0/16"
  data_storage_subnet_address_prefix = "10.2.1.0/24"
  database_subnet_address_prefix = "10.2.2.0/24"
  data_private_endpoint_subnet_address_prefix = "10.2.3.0/24"

  # Analytics Network Configuration
  analytics_vnet_address_space = "10.3.0.0/16"
  analytics_services_subnet_address_prefix = "10.3.1.0/24"
  data_factory_subnet_address_prefix = "10.3.2.0/24"
  analytics_private_endpoint_subnet_address_prefix = "10.3.3.0/24"
}

# Additional module configurations for other components...
