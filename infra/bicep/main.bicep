
targetScope = 'subscription'

// foundation resource group & resources
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

// GenAI FieldOps resource group & resources
resource genairg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: 'rg-vignette-genai-fieldops'
  location: deployment().location
}

module genaiFieldOps 'groups/genaiFieldOps.group.bicep' = {
  name: 'genaiFieldOps-deployment'
  scope: resourceGroup(genairg.name)

  params: {    
  }
}

// DataProfiling resource group & resources
resource dataProfilingRg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: 'rg-vignette-data-profiling'
  location: deployment().location
}

module dataProfiling 'groups/dataProfiling.group.bicep' = {
  name: 'dataProfiling-deployment'
  scope: resourceGroup(dataProfilingRg.name)

  params: {
  }
}

// Hosting resource group & resources
resource hostingRg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: 'rg-vignette-hosting'
  location: deployment().location
}

module hosting 'groups/hosting.group.bicep' = {
  name: 'hosting-deployment'
  scope: resourceGroup(hostingRg.name)

  params: {
  }
}
