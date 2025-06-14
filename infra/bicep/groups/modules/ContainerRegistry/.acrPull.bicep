
param containerRegistryName string
param objectId string

@allowed(['User', 'Group', 'ServicePrincipal'])
param principalType string = 'ServicePrincipal'

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2025-04-01' existing = {
  name: containerRegistryName
}

var acrPullRoleDefinitionValue = '7f951dda-4ed3-4680-a7ca-43fe172d538d'

resource acrPullRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(containerRegistry.id, objectId, acrPullRoleDefinitionValue)
  scope: containerRegistry
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions/', acrPullRoleDefinitionValue)
    principalId: objectId
    principalType: principalType
  }
}
