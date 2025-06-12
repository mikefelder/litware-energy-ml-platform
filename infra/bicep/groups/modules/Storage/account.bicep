
param resourceName string

@allowed(['Standard_LRS', 'Premium_LRS', 'Standard_GRS', 'Standard_RAGRS', 'Standard_ZRS'])
param skuName string = 'Standard_LRS'

@allowed(['Storage', 'StorageV2', 'BlobStorage'])
param kindName string = 'StorageV2'

param location string = resourceGroup().location

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: resourceName
  location: location
  sku: {
    name: skuName
  }
  kind: kindName
  properties: {
    accessTier: 'Hot'
  }
}

output resourceId string = storageAccount.id
