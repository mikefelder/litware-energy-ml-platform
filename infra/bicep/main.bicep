
targetScope = 'subscription'

resource mlrg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: 'rg-vignette-ai-ml-foundation'
  location: deployment().location
}

module mlFoundation 'groups/mlFoundation.group.bicep' = {
  name: 'mlFoundation-deployment'
  scope: resourceGroup(mlrg.name)

  params: {
  }
}
