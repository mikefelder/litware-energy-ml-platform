
param location string = resourceGroup().location

module naming './modules/naming.bicep' = {
  name: 'naming-nodeploy'
}

var locationShorthand = naming.outputs.locationShorthand[location]
module foundationIdentity 'modules/ManagedIdentity/userAssignedIdentities.bicep' = {
  name: 'mlFoundation-identity-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.userIdentity.prefix}-foundation-${locationShorthand}'
  }
}

output userAssignedIdentityResourceName string = foundationIdentity.outputs.resourceName
output userAssignedIdentityPrincipalId string = foundationIdentity.outputs.principalId
