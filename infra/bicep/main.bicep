
targetScope = 'subscription'

// resource groups
resource mlrg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: 'rg-vignette-ai-ml-foundation'
  location: deployment().location
}

resource identityRg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: 'rg-vignette-ai-ml-identity'
  location: deployment().location
}

// populate resource groups
module mlIdentity 'groups/mlIdentity.group.bicep' = {
  name: 'mlIdentity-deployment'
  scope: resourceGroup(identityRg.name)

  params: {
  }
}

// assign user access admin role to the identity resource group
// we use a scoped module to specifically target the foundation rg
module userAccessAdminAssign 'groups/modules/Authorization/userAccessAdministrator.bicep' = {
  name: 'userAccessAdminAssign-deployment'
  scope: resourceGroup(mlrg.name)

  params: {
    objectId: mlIdentity.outputs.userAssignedIdentityPrincipalId
  }
}

module mlFoundation 'groups/mlFoundation.group.bicep' = {
  name: 'mlFoundation-deployment'
  scope: resourceGroup(mlrg.name)

  params: {
    foundationIdentityResourceName: mlIdentity.outputs.userAssignedIdentityResourceName
    foundationIdentityResourceGroupName: identityRg.name
  }
}
