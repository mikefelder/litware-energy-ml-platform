terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.29.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
  }
  required_version = ">= 1.0"
}

# Configure Azure RM provider
provider "azurerm" {
  features {}
}

# Configure Azure AD provider
provider "azuread" {
  # No additional configuration needed if using Azure CLI authentication
}