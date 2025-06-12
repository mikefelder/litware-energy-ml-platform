
param resourceName string
param location string = resourceGroup().location

@secure()
param synapseAdminUsername string

@secure()
param synapseAdminPassword string

resource synapse 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: resourceName
  location: location
  identity: {
    type: 'SystemAssigned'
  }

  properties: {
    managedResourceGroupName: 'rg-managed-${resourceName}'
    defaultDataLakeStorage: {
      accountUrl: 'https://${resourceName}.dfs.${environment().suffixes.storage}'
      filesystem: 'default'
    }
    sqlAdministratorLogin: synapseAdminUsername
    sqlAdministratorLoginPassword: synapseAdminPassword
    publicNetworkAccess: 'Enabled'
  }
}

output resourceId string = synapse.id
output resourceName string = synapse.name
output principalId string = synapse.identity.principalId
