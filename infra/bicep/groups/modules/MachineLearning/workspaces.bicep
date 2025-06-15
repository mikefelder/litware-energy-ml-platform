
param resourceName string
param location string = resourceGroup().location

param storageAccountId string
param keyVaultId string
param appInsightsId string
param containerRegistryId string = ''

@allowed(['Default', 'AmlCompute', 'AmlComputeV2', 'BatchAI', 'DataFactory', 'DataScienceVM', 'Databricks', 'HDInsight', 'SparkPool'])
param kindName string = 'Default'

param skuName string = 'Basic'
param skuTier string = 'Basic'

@allowed(['SystemAssigned', 'UserAssigned'])
param identityType string = 'SystemAssigned'
param userManagedIdentityId string = ''

var identityBlock = identityType == 'SystemAssigned' ? {
  type: 'SystemAssigned'
} : {
  type: 'UserAssigned'
  userAssignedIdentities: {
    '${userManagedIdentityId}': {}
  }
}

resource amlWorkspace 'Microsoft.MachineLearningServices/workspaces@2025-04-01' = {
  name: resourceName
  location: location

  kind: kindName
  sku: {
    name: skuName
    tier: skuTier
  }
  identity: identityBlock
  properties: {
    allowPublicAccessWhenBehindVnet: false
    storageAccount: storageAccountId
    keyVault: keyVaultId
    applicationInsights: appInsightsId
    containerRegistry: containerRegistryId == '' ? null : containerRegistryId
    publicNetworkAccess: 'Enabled'
    friendlyName: resourceName
    primaryUserAssignedIdentity: identityType == 'UserAssigned' ? userManagedIdentityId : null
  }
}

module workspaceCompute './workspaces/compute.bicep' = {
  name: '${resourceName}-compute-deployment'
  params: {
    resourceName: '${resourceName}-compute'
    mlStudioResourceName: amlWorkspace.name
    identityType: identityType
    userManagedIdentityId: userManagedIdentityId
  }
}

output resourceId string = amlWorkspace.id
output resourceName string = amlWorkspace.name
output principalId string = identityType == 'SystemAssigned' ? amlWorkspace.identity.principalId : ''
