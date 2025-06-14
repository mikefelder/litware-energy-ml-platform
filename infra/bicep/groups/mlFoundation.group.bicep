
param location string = resourceGroup().location
param foundationIdentityResourceName string
param foundationIdentityResourceGroupName string = resourceGroup().name

module naming './modules/naming.bicep' = {
  name: 'naming-nodeploy'
}

resource foundationIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2025-01-31-preview' existing = {
  name: foundationIdentityResourceName
  scope: resourceGroup(foundationIdentityResourceGroupName)
}

var locationShorthand = naming.outputs.locationShorthand[location]
module modelRegistry 'modules/ContainerRegistry/registries.bicep' = {
  name: 'mlFoundation-registry-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.containerRegistry.prefix}foundation${locationShorthand}'
    acrPushAssignments: [
      {
        objectId: foundationIdentity.properties.principalId
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
    blobDataContributorRoleAssignments: [
      {
        objectId: foundationIdentity.properties.principalId
      }
    ]
  }
}

module workspaceKeyVault 'modules/KeyVault/vaults.bicep' = {
  name: 'workspace-keyvault-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.keyVault.prefix}-foundation-${locationShorthand}'
    location: location
    keyVaultSecretsOfficerAssignments: [
      {
        objectId: foundationIdentity.properties.principalId
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
    identityType: 'UserAssigned'
    userManagedIdentityId: foundationIdentity.id
  }
}
//
//module storageContributorRoleAssignment 'modules/Authorization/blobDataContributor.bicep' = {
//  name: 'foundation-storage-contributor-role-assignment'
//  params: {
//    storageAccountName: storageAccountName
//    objectId: mlWorkspace.outputs.computerPrincipalId
//  }
//}
