
param location string = resourceGroup().location

module naming './modules/naming.bicep' = {
  name: 'naming-nodeploy'
}

module foundationIdentity 'modules/ManagedIdentity/userAssignedIdentities.bicep' = {
  name: 'mlFoundation-identity-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.userIdentity.prefix}-foundation-${locationShorthand}'
  }
}

var locationShorthand = naming.outputs.locationShorthand[location]
module modelRegistry 'modules/ContainerRegistry/registries.bicep' = {
  name: 'mlFoundation-registry-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.containerRegistry.prefix}foundation${locationShorthand}'
    acrPushAssignments: [
      {
        objectId: foundationIdentity.outputs.principalId
      }
    ]
  }
}

module workspaceAnalytics 'modules/OperationalInsights/workspaces.bicep' = {
  name: 'workspace-foundation-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.logAnalytics.prefix}-foundation-${locationShorthand}'
    location: location
  }
}

module appInsights 'modules/Insights/components.bicep' = {
  name: 'appinsights-foundation-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.appInsights.prefix}-foundation-${locationShorthand}'
    workspaceId: workspaceAnalytics.outputs.resourceId
    location: location
  }
}

var storageAccountName = '${naming.outputs.resourceNaming.storageAccount.prefix}mlfoundation${locationShorthand}'
module workspaceStorageAccount 'modules/Storage/account.bicep' = {
  name: 'workspace-foundation-storage-deployment'
  params: {
    resourceName: storageAccountName
    useSharedKey: true
  }
}

module workspaceKeyVault 'modules/KeyVault/vaults.bicep' = {
  name: 'workspace-keyvault-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.keyVault.prefix}-foundation-${locationShorthand}'
    location: location
    keyVaultSecretsOfficerAssignments: [
      {
        objectId: foundationIdentity.outputs.principalId
      }
    ]
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
    containerRegistryId: modelRegistry.outputs.resourceId
    userManagedIdentityId: foundationIdentity.outputs.resourceId
  }
}
