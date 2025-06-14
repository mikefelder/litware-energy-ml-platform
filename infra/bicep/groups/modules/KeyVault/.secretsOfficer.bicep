
param keyVaultName string
param objectId string

@allowed(['User', 'Group', 'ServicePrincipal'])
param principalType string = 'ServicePrincipal'

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyVaultName
}

var secretsOfficerRoleDefinitionValue = 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7'
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVault.id, objectId, secretsOfficerRoleDefinitionValue)
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions/', secretsOfficerRoleDefinitionValue)
    principalId: objectId
    principalType: principalType
  }
}
