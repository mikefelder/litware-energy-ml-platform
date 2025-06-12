
@description('The name of the Application Insights resource.')
param resourceName string

@description('The name of the Application Insights Workspace resource.')
param workspaceId string

param location string = resourceGroup().location

@allowed(['other', 'web'])
param applicationType string = 'web'

@allowed(['web', 'ios', 'other', 'store', 'java', 'phone'])
param kindName string = 'web'

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: resourceName
  location: location
  kind: kindName
  properties: {
    Application_Type: applicationType
    Request_Source: 'rest'
    Flow_Type: 'Bluefield'
    WorkspaceResourceId: workspaceId
  }
}

output resourceId string = appInsights.id
