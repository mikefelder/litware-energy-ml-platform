# Networking Infrastructure Module

This module implements the core networking infrastructure for the Litware Energy ML Platform. It creates a hub-and-spoke network architecture with dedicated VNets for different service categories.

## Network Design

The network infrastructure is divided into four Virtual Networks:

1. Hub VNet (10.0.0.0/16)
   - GatewaySubnet: 10.0.0.0/24 - For Azure Gateway services
   - AzureBastionSubnet: 10.0.1.0/24 - For Azure Bastion host
   - SharedServicesSubnet: 10.0.2.0/24 - For shared services

2. ML Services VNet (10.1.0.0/16)
   - AksSystemNodesSubnet: 10.1.0.0/21 - For AKS system nodes (supports up to 2000 pods)
   - AksUserNodesSubnet: 10.1.8.0/21 - For AKS user nodes (supports up to 2000 pods)
   - MlServicesSubnet: 10.1.16.0/22 - For ML services and compute instances
   - PrivateEndpointsSubnet: 10.1.20.0/24 - For private endpoints

3. Data Services VNet (10.2.0.0/16)
   - DatabaseSubnet: 10.2.0.0/23 - For database services
   - RedisSubnet: 10.2.2.0/24 - For Redis Cache instances
   - StorageSubnet: 10.2.3.0/24 - For storage services
   - PrivateEndpointsSubnet: 10.2.4.0/24 - For private endpoints

4. Analytics VNet (10.3.0.0/16)
   - AnalyticsSubnet: 10.3.0.0/22 - For analytics services
   - DataLakeSubnet: 10.3.4.0/23 - For data lake services
   - MonitoringSubnet: 10.3.6.0/24 - For monitoring services
   - PrivateEndpointsSubnet: 10.3.7.0/24 - For private endpoints

## Design Rationale

1. Subnet Sizing:
   - AKS subnets are sized at /21 to support up to 2000 pods per subnet
   - Service-specific subnets are sized based on expected resource count and growth
   - Private endpoint subnets are /24 to accommodate multiple endpoints
   - Gateway and Bastion subnets follow Azure requirements

2. Network Segregation:
   - Each major service category has its own VNet for isolation
   - Private endpoints are segregated in dedicated subnets
   - Service endpoints are configured for required Azure services

3. Security Considerations:
   - NSGs are applied at subnet level
   - Service endpoints reduce exposure to public internet
   - Azure Bastion provides secure VM access

## Usage

To use this module, provide the required variables:

```hcl
module "networking" {
  source              = "./modules/networking"
  prefix              = "litware"
  environment         = "dev"
  location            = "eastus"
  resource_group_name = "rg-litware-networking-dev"
  tags                = {
    Environment = "Development"
    Terraform   = "true"
  }
}
```

## Variables

See variables.tf for all available configuration options.