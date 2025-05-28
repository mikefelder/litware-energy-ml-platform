locals {
  # Generate random string for unique names
  random_safe_generation = random_string.safe.result

  # Prefix and suffix settings
  prefix = var.prefix != null ? var.prefix : ""
  suffix = var.suffix != null ? var.suffix : []
  suffix_unique = concat(var.suffix, [random_string.safe.result])
  
  # Validation rules for naming convention
  validation = {
    prefix_validation = can(regex("^[a-z0-9][a-z0-9-]{1,60}[a-z0-9]$", local.prefix))
    suffix_validation = can(regex("^[a-z0-9][a-z0-9-]{1,60}[a-z0-9]$", join("-", local.suffix)))
  }

  # Azure resource naming rules using submodules
  az = merge(
    module.compute.naming_rules,
    module.storage.naming_rules,
    module.networking.naming_rules,
    module.database.naming_rules,
    module.analytics.naming_rules,
    module.integration.naming_rules,
    module.security.naming_rules,
    module.web.naming_rules,
    module.containers.naming_rules,
    module.cognitive.naming_rules
  )
}

# Random string for unique resource names
resource "random_string" "safe" {
  length  = var.unique-length
  special = false
  upper   = false
  numeric = var.unique-include-numbers
}

# Submodules for different Azure service types
module "compute" {
  source = "./modules/compute"
  name = ""
  prefixes = [local.prefix]
  suffixes = local.suffix
  delimiter = "-"
  random_length = var.unique-length
}

module "storage" {
  source = "./modules/storage"
  name = ""
  prefixes = [local.prefix]
  suffixes = local.suffix
  delimiter = "-"
  random_length = var.unique-length
}

module "networking" {
  source = "./modules/networking"
  name = ""
  prefixes = [local.prefix]
  suffixes = local.suffix
  delimiter = "-"
  random_length = var.unique-length
}

module "database" {
  source = "./modules/database"
  name = ""
  prefixes = [local.prefix]
  suffixes = local.suffix
  delimiter = "-"
  random_length = var.unique-length
}

module "analytics" {
  source = "./modules/analytics"
  name = ""
  prefixes = [local.prefix]
  suffixes = local.suffix
  delimiter = "-"
  random_length = var.unique-length
}

module "integration" {
  source = "./modules/integration"
  name = ""
  prefixes = [local.prefix]
  suffixes = local.suffix
  delimiter = "-"
  random_length = var.unique-length
}

module "security" {
  source = "./modules/security"
  name = ""
  prefixes = [local.prefix]
  suffixes = local.suffix
  delimiter = "-"
  random_length = var.unique-length
}

module "web" {
  source = "./modules/web"
  name = ""
  prefixes = [local.prefix]
  suffixes = local.suffix
  delimiter = "-"
  random_length = var.unique-length
}

module "containers" {
  source = "./modules/containers"
  name = ""
  prefixes = [local.prefix]
  suffixes = local.suffix
  delimiter = "-"
  random_length = var.unique-length
}

module "cognitive" {
  source = "./modules/cognitive"
  name = ""
  prefixes = [local.prefix]
  suffixes = local.suffix
  delimiter = "-"
  random_length = var.unique-length
}