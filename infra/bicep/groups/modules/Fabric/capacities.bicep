
param resourceName string
param location string = resourceGroup().location

@allowed([ 'Fabric' ])
param tierName string = 'Fabric'

@allowed([
  'F2'
  'F4'
  'F8'
  'F16'
  'F32'
  'F64'
  'F128'
  'F256'
  'F512'
  'F1024'
  'F2048'
])
@description('Optional. SKU tier of the Fabric resource.')
param skuName string = 'F2'

@minLength(1)
param adminstrationMembersEmailArray array

resource fabricCapacity 'Microsoft.Fabric/capacities@2023-11-01' = {
  name: resourceName
  location: location
  sku: {
    tier: tierName
    name: skuName
  }

  properties: {
    administration: {
      members: adminstrationMembersEmailArray
    }
  }
}

output resourceId string = fabricCapacity.id
output resourceName string = fabricCapacity.name
