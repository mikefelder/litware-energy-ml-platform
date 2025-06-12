
param location string = resourceGroup().location

module naming 'modules/naming.bicep' = {
  name: 'naming'
}

var locationShorthand = naming.outputs.locationShorthand[location]
module foundary 'modules/CognitiveServices/accounts.bicep' = {
  name: 'foundary-foundation-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.foundary.prefix}-genaifieldops-${locationShorthand}'
    location: location
  }
}

module search 'modules/Search/searchService.bicep' = {
  name: 'search-service-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.search.prefix}-genaifieldops-${locationShorthand}'
    location: location
  }
}
