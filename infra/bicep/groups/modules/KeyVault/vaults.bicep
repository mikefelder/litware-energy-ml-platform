
param resourceName string
param location string = resourceGroup().location

@allowed(['standard', 'premium'])
@description('The SKU name for the Key Vault. Allowed values are "standard" and "premium".')
param skuName string = 'standard'

@allowed(['A', 'B'])
@description('The SKU family for the Key Vault. Allowed values are "A" and "B".')
param skuFamily string = 'A'

param useRbacAccessControl bool = true

@description('List of objects containing the keys objectId and principalType (optional, defaults to ServicePrincipal) that should be assigned the ACR Pull role.')
param keyVaultSecretsOfficerAssignments array = []

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: resourceName
  location: location

  properties: {
    sku: {
      family: skuFamily
      name: skuName
    }
    tenantId: subscription().tenantId
    accessPolicies: []
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    enableRbacAuthorization: useRbacAccessControl
  }
}

module acrPushRoleAssignments '.secretsOfficer.bicep' = [for item in keyVaultSecretsOfficerAssignments: {
  name: 'acrPushAssignment-${item.objectId}'
  params: {
    keyVaultName: keyVault.name
    objectId: item.objectId
    principalType: item.?principalType ?? 'ServicePrincipal'
  }
}]

output resourceId string = keyVault.id
