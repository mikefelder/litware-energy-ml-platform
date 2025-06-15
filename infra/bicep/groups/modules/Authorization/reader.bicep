
param objectId string

@allowed(['storageAccount'])
param targetResourceType string = 'storageAccount'
param targetResourceName string

@allowed(['User', 'Group', 'ServicePrincipal'])
param principalType string = 'ServicePrincipal'

var readeroleDefinitionId = 'acdd72a7-3385-48ef-bd42-f606fba81ae7'

resource sa 'Microsoft.Storage/storageAccounts@2024-01-01' existing = if (targetResourceType == 'storageAccount') {
  name: targetResourceName
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (targetResourceType == 'storageAccount') {
  name: guid(resourceGroup().id, objectId, readeroleDefinitionId)
  scope: sa
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions/', readeroleDefinitionId)
    principalId: objectId
    principalType: principalType
  }
}
