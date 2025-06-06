
param resourceName string
param location string = resourceGroup().location

param logAnalyticsResourceName string
param logAnalyticsResourceGroupName string = resourceGroup().name

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' existing = {
  name: logAnalyticsResourceName
  scope: resourceGroup(logAnalyticsResourceGroupName)
}

var sharedKeys = listKeys(logAnalyticsWorkspace.id, logAnalyticsWorkspace.apiVersion)
resource containerAppEnv 'Microsoft.App/managedEnvironments@2025-02-02-preview' = {
  name: resourceName
  location: location

  identity: {
    type: 'SystemAssigned'
  }

  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsWorkspace.properties.customerId
        sharedKey: sharedKeys.primarySharedKey
      }
    }
    workloadProfiles: [
      {
        workloadProfileType: 'Consumption'
        name: 'Consumption'
      }
    ]
  }
}

output resourceId string = containerAppEnv.id
output resourceName string = containerAppEnv.name
