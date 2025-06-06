
param resourceName string
param location string = resourceGroup().location

@allowed([ 'Basic', 'Standard', 'Premium' ])
param skuName string = 'Standard'

param adminUserEnabled bool = false

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: resourceName
  location: location
  sku: {
    name: skuName
  }
  properties: {
    adminUserEnabled: adminUserEnabled
    publicNetworkAccess: 'Enabled'
  }
}

output resourceName string = containerRegistry.name
output resourceId string = containerRegistry.id
