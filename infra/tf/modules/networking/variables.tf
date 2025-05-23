variable "prefix" {
  description = "Prefix for all resources"
  type        = string
}

variable "environment" {
  description = "Environment name for resource naming"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "hub_address_space" {
  description = "Address space for hub VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "hub_subnets" {
  description = "Subnets configuration for hub VNet"
  type = list(object({
    name           = string
    address_prefix = string
  }))
  default = [
    {
      name           = "GatewaySubnet"
      address_prefix = "10.0.0.0/24"
    },
    {
      name           = "AzureBastionSubnet"
      address_prefix = "10.0.1.0/24"
    },
    {
      name           = "SharedServicesSubnet"
      address_prefix = "10.0.2.0/24"
    }
  ]
}

variable "ml_services_address_space" {
  description = "Address space for ML Services VNet"
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "ml_services_subnets" {
  description = "Subnets configuration for ML Services VNet"
  type = list(object({
    name           = string
    address_prefix = string
  }))
  default = [
    {
      name           = "AksSystemNodesSubnet"
      address_prefix = "10.1.0.0/21"    # /21 for AKS system nodes
    },
    {
      name           = "AksUserNodesSubnet"
      address_prefix = "10.1.8.0/21"    # /21 for AKS user nodes
    },
    {
      name           = "MlServicesSubnet"
      address_prefix = "10.1.16.0/22"   # /22 for ML services
    },
    {
      name           = "PrivateEndpointsSubnet"
      address_prefix = "10.1.20.0/24"   # /24 for private endpoints
    }
  ]
}

variable "data_services_address_space" {
  description = "Address space for Data Services VNet"
  type        = list(string)
  default     = ["10.2.0.0/16"]
}

variable "data_services_subnets" {
  description = "Subnets configuration for Data Services VNet"
  type = list(object({
    name           = string
    address_prefix = string
  }))
  default = [
    {
      name           = "DatabaseSubnet"
      address_prefix = "10.2.0.0/23"    # /23 for databases
    },
    {
      name           = "RedisSubnet"
      address_prefix = "10.2.2.0/24"    # /24 for Redis Cache
    },
    {
      name           = "StorageSubnet"
      address_prefix = "10.2.3.0/24"    # /24 for storage services
    },
    {
      name           = "PrivateEndpointsSubnet"
      address_prefix = "10.2.4.0/24"    # /24 for private endpoints
    }
  ]
}

variable "analytics_address_space" {
  description = "Address space for Analytics VNet"
  type        = list(string)
  default     = ["10.3.0.0/16"]
}

variable "analytics_subnets" {
  description = "Subnets configuration for Analytics VNet"
  type = list(object({
    name           = string
    address_prefix = string
  }))
  default = [
    {
      name           = "AnalyticsSubnet"
      address_prefix = "10.3.0.0/22"    # /22 for analytics services
    },
    {
      name           = "DataLakeSubnet"
      address_prefix = "10.3.4.0/23"    # /23 for data lake services
    },
    {
      name           = "MonitoringSubnet"
      address_prefix = "10.3.6.0/24"    # /24 for monitoring services
    },
    {
      name           = "PrivateEndpointsSubnet"
      address_prefix = "10.3.7.0/24"    # /24 for private endpoints
    }
  ]
}

variable "ai_services_address_space" {
  description = "Address space for AI Services VNet"
  type        = list(string)
  default     = ["10.4.0.0/16"]
}

variable "ai_services_subnets" {
  description = "Subnets configuration for AI Services VNet"
  type = list(object({
    name           = string
    address_prefix = string
  }))
  default = [
    {
      name           = "AiServicesSubnet"
      address_prefix = "10.4.0.0/24"    # Main subnet for AI services
    },
    {
      name           = "DocumentIntelligenceSubnet"
      address_prefix = "10.4.1.0/24"    # For Document Intelligence services
    },
    {
      name           = "OpenAISubnet"
      address_prefix = "10.4.2.0/24"    # For OpenAI deployments
    },
    {
      name           = "SearchSubnet"
      address_prefix = "10.4.3.0/24"    # For Azure Search services
    },
    {
      name           = "StorageSubnet"
      address_prefix = "10.4.4.0/24"    # For Storage services
    },
    {
      name           = "PrivateEndpointsSubnet"
      address_prefix = "10.4.5.0/24"    # For private endpoints
    }
  ]
}
