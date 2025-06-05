
param location string = resourceGroup().location

module naming './modules/naming.bicep' = {
  name: 'naming-nodeploy'
}

var locationShorthand = naming.outputs.locationShorthand[location]

var storageAccountName = '${naming.outputs.resourceNaming.storageAccount.prefix}mlfoundation${locationShorthand}'
module workspaceStorageAccount 'modules/Storage/account.bicep' = {
  name: 'workspace-storage-deployment'
  params: {
    resourceName: storageAccountName
    location: location
  }
}

module workspaceKeyVault 'modules/KeyVault/vaults.bicep' = {
  name: 'workspace-keyvault-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.keyVault.prefix}-foundation-${locationShorthand}'
    location: location
  }
}

module workspaceAnalytics './modules/OperationalInsights/workspaces.bicep' = {
  name: 'workspace-analytics-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.logAnalytics.prefix}-foundation-${locationShorthand}'
    location: location
  }
}

module appInsights 'modules/Insights/components.bicep' = {
  name: 'appinsights-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.appInsights.prefix}-foundation-${locationShorthand}'
    workspaceId: workspaceAnalytics.outputs.resourceId
    location: location
  }
}

module mlWorkspace 'modules/MachineLearning/workspaces.bicep' = {
  name: 'mlFoundation-workspace-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.machineLearning.prefix}-foundation-${locationShorthand}'
    location: location
    storageAccountId: workspaceStorageAccount.outputs.resourceId
    keyVaultId: workspaceKeyVault.outputs.resourceId
    appInsightsId: appInsights.outputs.resourceId
  }
}
