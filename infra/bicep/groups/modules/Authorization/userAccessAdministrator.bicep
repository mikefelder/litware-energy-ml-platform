
param objectId string

@allowed(['User', 'Group', 'ServicePrincipal'])
param principalType string = 'ServicePrincipal'

var uAARoleDefinitionId = '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, objectId, uAARoleDefinitionId)
  scope: resourceGroup()
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions/', uAARoleDefinitionId)
    principalId: objectId
    principalType: principalType
  }
}
