
param objectId string

@allowed(['storageAccount'])
param targetResourceType string = 'storageAccount'
param targetResourceName string

@allowed(['User', 'Group', 'ServicePrincipal'])
param principalType string = 'ServicePrincipal'

var uAARoleDefinitionId = '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'

resource sa 'Microsoft.Storage/storageAccounts@2024-01-01' existing = if (targetResourceType == 'storageAccount') {
  name: targetResourceName
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (targetResourceType == 'storageAccount') {
  name: guid(resourceGroup().id, objectId, uAARoleDefinitionId)
  scope: sa
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions/', uAARoleDefinitionId)
    principalId: objectId
    principalType: principalType
  }
}
