
param resourceName string

@allowed(['Standard_LRS', 'Premium_LRS', 'Standard_GRS', 'Standard_RAGRS', 'Standard_ZRS'])
param skuName string = 'Standard_LRS'

@allowed(['Storage', 'StorageV2', 'BlobStorage'])
param kindName string = 'StorageV2'

param location string = resourceGroup().location

@description('List of objects containing the keys objectId and principalType (optional, defaults to ServicePrincipal) that should be assigned the ACR Push role.')
param blobDataContributorRoleAssignments array = []

@description('List of objects containing the keys objectId and principalType (optional, defaults to ServicePrincipal) that should be assigned the ACR Push role.')
param fileDataContributorRoleAssignments array = []

param useSharedKey bool = false

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: resourceName
  location: location
  sku: {
    name: skuName
  }
  kind: kindName
  properties: {
    accessTier: 'Hot'
    allowSharedKeyAccess: useSharedKey
  }
}

module blobDataContributorRoleAssignment '.storageBlobDataContributor.bicep' = [for item in blobDataContributorRoleAssignments: {
  name: '${substring(resourceName,10)}-blobSvcContrib-${item.objectId}'
  params: {
    storageAccountName: storageAccount.name
    objectId: item.objectId
    principalType: item.?principalType ?? 'ServicePrincipal'
  }
}]

module fileDataPrivilegedContributorRoleAssignment '.storageFileDataPrivilegedContributor.bicep' = [for item in fileDataContributorRoleAssignments: {
  name: '${substring(resourceName,10)}-fileSvcContrib-${item.objectId}'
  params: {
    storageAccountName: storageAccount.name
    objectId: item.objectId
    principalType: item.?principalType ?? 'ServicePrincipal'
  }
}]

output resourceId string = storageAccount.id
