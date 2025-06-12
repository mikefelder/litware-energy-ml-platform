
param resourceName string
param location string = resourceGroup().location

@allowed(['standard', 'premium'])
@description('The SKU name for the Key Vault. Allowed values are "standard" and "premium".')
param skuName string = 'standard'

@allowed(['A', 'B'])
@description('The SKU family for the Key Vault. Allowed values are "A" and "B".')
param skuFamily string = 'A'

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
  }
}

output resourceId string = keyVault.id
