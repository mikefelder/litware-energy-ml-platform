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

  # Using default subnet configurations defined in the networking module
  # These can be overridden if needed for specific environments
}
