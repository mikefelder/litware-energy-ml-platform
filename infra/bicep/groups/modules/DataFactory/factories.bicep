
param resourceName string
param location string = resourceGroup().location

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: resourceName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  
  properties: {
    publicNetworkAccess: 'Enabled'
  }
}

output resourceId string = dataFactory.id
