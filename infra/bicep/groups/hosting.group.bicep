
param location string = resourceGroup().location

module naming 'modules/naming.bicep' = {
  name: 'naming-hosting-deployment'
  params: {
  }
}

var locationShorthand = naming.outputs.locationShorthand[location]

// container registry
module containerRegistry 'modules/ContainerRegistry/registries.bicep' = {
  name: 'containerRegistry-hosting-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.containerRegistry.prefix}analyticshosting${locationShorthand}'
    location: location
    skuName: 'Standard'
    adminUserEnabled: false
  }
}

// managed user
module managedUser 'modules/ManagedIdentity/userAssignedIdentities.bicep' = {
  name: 'managedUser-hosting-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.userIdentify.prefix}analyticshosting${locationShorthand}'
    location: location
  }
}

// rbac
module acrPullRoleAssignment 'modules/Authorization/roleAssignments/acrPull.bicep' = {
  name: 'acrPullRoleAssignment-hosting-deployment'
  params: {
    containerRegistryName: containerRegistry.outputs.resourceName
    objectId: managedUser.outputs.principalId
  }
}

// log analytics workspace
module workspaceAnalytics 'modules/OperationalInsights/workspaces.bicep' = {
  name: 'workspace-hosting-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.logAnalytics.prefix}-hosting-${locationShorthand}'
    location: location
  }
}

// app insights
module appInsights 'modules/Insights/components.bicep' = {
  name: 'appinsights-hosting-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.appInsights.prefix}-hosting-${locationShorthand}'
    workspaceId: workspaceAnalytics.outputs.resourceId
    location: location
  }
}

// environment
module managedEnvironment 'modules/App/managedEnvironments.bicep' = {
  name: 'managedEnvironment-hosting-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.containerAppEnv.prefix}-hosting-${locationShorthand}'
    location: location
    logAnalyticsResourceName: workspaceAnalytics.outputs.resourceName
  }
}

// aca instance
module acaInstance 'modules/App/containerApps.bicep' = {
  name: 'acaInstance-hosting-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.containerApp.prefix}-hosting-${locationShorthand}'
    location: location
    managedEnvironmentId: managedEnvironment.outputs.resourceId
    containerPort: 80
    useExternalIngress: true
    userAssignedIdentityId: managedUser.outputs.resourceId
    containers: [
      {
        container_name: 'test-web-server'
        image_name: 'nginx'
      }
    ]
  }
}
