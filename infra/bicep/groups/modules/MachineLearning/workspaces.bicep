
param resourceName string
param storageAccountId string
param keyVaultId string
param location string = resourceGroup().location

@allowed(['Default', 'AmlCompute', 'AmlComputeV2', 'BatchAI', 'DataFactory', 'DataScienceVM', 'Databricks', 'HDInsight', 'SparkPool'])
param kindName string = 'Default'

param skuName string = 'Basic'
param skuTier string = 'Basic'

resource amlWorkspace 'Microsoft.MachineLearningServices/workspaces@2025-04-01' = {
  name: resourceName
  location: location

  kind: kindName
  sku: {
    name: skuName
    tier: skuTier
  }
  identity: {
    type: 'SystemAssigned'
  }
  
  properties: {
    allowPublicAccessWhenBehindVnet: false
    storageAccount: storageAccountId
    keyVault: keyVaultId
    friendlyName: resourceName
  }
}
