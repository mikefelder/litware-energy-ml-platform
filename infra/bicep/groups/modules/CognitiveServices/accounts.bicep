
param resourceName string
param location string = resourceGroup().location

@allowed([ 'CognitiveServices', 'SpeechServices', 'VisionServices', 'LanguageServices', 'DecisionServices', 'OpenAI', 'AIServices' ])
param kindName string = 'AIServices'

param skuName string = 'S0'

resource cognitiveAccount 'Microsoft.CognitiveServices/accounts@2025-04-01-preview' = {
  name: resourceName
  location: location
  identity: {
    type: 'SystemAssigned'
  }

  kind: kindName
  sku: {
    name: skuName
  }

  properties: {
    publicNetworkAccess: 'Enabled'
    customSubDomainName: resourceName
  }
}
