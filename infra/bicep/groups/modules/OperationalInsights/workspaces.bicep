
param resourceName string
param location string = resourceGroup().location

@minValue(1)
param rententionInDays int = 30

@allowed([
  'CapacityReservation'
  'Free'
  'LACluster'
  'PerGB2018'
  'PerNode'
  'Premium'
  'Standalone'
  'Standard'
])
param skuName string = 'PerGB2018'

resource workspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' = {
  name: resourceName
  location: location
  properties: {
    retentionInDays: rententionInDays
    sku: {
      name: skuName
    }
    features: {
      searchVersion: 1
    }
  }
}

output resourceId string = workspace.id
