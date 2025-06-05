
param resourceName string
param location string = resourceGroup().location

@allowed(['basic', 'free', 'standard', 'standard2', 'standard3', 'storage_optimized_l1', 'storage_optimized_l2'])
param skuName string = 'standard'

@allowed(['default', 'highDensity'])
param hostingMode string = 'default'

@minValue(1)
param partitionCount int = 1

@minValue(1)
param replicaCount int = 1

//@allowed(['default', 'confidential'])
//param computeType string = 'default'

resource searchService 'Microsoft.Search/searchServices@2025-02-01-preview' = {
  name: resourceName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: skuName
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    hostingMode: hostingMode
    partitionCount: partitionCount
    replicaCount: replicaCount
    //computeType: computeType
  }
}
