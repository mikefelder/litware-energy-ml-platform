
param storageAccountName string
param objectId string

@allowed(['User', 'Group', 'ServicePrincipal'])
param principalType string = 'ServicePrincipal'

resource sa 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: storageAccountName
}

resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2024-01-01' existing = {
  name: 'default'
  parent: sa
}

var storageBlobDataContributorRoleDefinitionValue = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'

resource storageBlobDataContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(blobServices.id, objectId, storageBlobDataContributorRoleDefinitionValue)
  scope: blobServices
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions/', storageBlobDataContributorRoleDefinitionValue)
    principalId: objectId
    principalType: principalType
  }
}
