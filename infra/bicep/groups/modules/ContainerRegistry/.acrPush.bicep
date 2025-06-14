
param containerRegistryName string
param objectId string

@allowed(['User', 'Group', 'ServicePrincipal'])
param principalType string = 'ServicePrincipal'

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2025-04-01' existing = {
  name: containerRegistryName
}

var acrPushRoleDefinitionValue = '8311e382-0749-4cb8-b61a-304f252e45ec'
resource acrPullRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(containerRegistry.id, objectId, acrPushRoleDefinitionValue)
  scope: containerRegistry
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions/', acrPushRoleDefinitionValue)
    principalId: objectId
    principalType: principalType
  }
}
