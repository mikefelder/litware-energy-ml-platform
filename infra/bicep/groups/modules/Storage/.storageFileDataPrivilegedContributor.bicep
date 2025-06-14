
param storageAccountName string
param objectId string

@allowed(['User', 'Group', 'ServicePrincipal'])
param principalType string = 'ServicePrincipal'

resource sa 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: storageAccountName
}

resource fileServices 'Microsoft.Storage/storageAccounts/fileServices@2024-01-01' existing = {
  name: 'default'
  parent: sa
}

var roleDefinitionId = '69566ab7-960f-475b-8e7c-b3118f30c6bd'
resource storageBlobDataContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(fileServices.id, objectId, roleDefinitionId)
  scope: fileServices
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions/', roleDefinitionId)
    principalId: objectId
    principalType: principalType
  }
}
