
param resourceName string
param location string = resourceGroup().location

@allowed([ 'Basic', 'Standard', 'Premium' ])
param skuName string = 'Standard'

param adminUserEnabled bool = false

@description('List of objects containing the keys objectId and principalType (optional, defaults to ServicePrincipal) that should be assigned the ACR Push role.')
param acrPushAssignments array = []

@description('List of objects containing the keys objectId and principalType (optional, defaults to ServicePrincipal) that should be assigned the ACR Pull role.')
param acrPullAssignments array = []

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

module acrPushRoleAssignments '.acrPush.bicep' = [for item in acrPushAssignments: {
  name: 'acrPushAssignment-${item.objectId}'
  params: {
    containerRegistryName: containerRegistry.name
    objectId: item.objectId
    principalType: item.?principalType ?? 'ServicePrincipal'
  }
}]

module acrPullRoleAssignments '.acrPull.bicep' = [for item in acrPullAssignments: {
  name: 'acrPullAssignment-${item.objectId}'
  params: {
    containerRegistryName: containerRegistry.name
    objectId: item.objectId
    principalType: item.?principalType ?? 'ServicePrincipal'
  }
}]

output resourceName string = containerRegistry.name
output resourceId string = containerRegistry.id
