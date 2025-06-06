
param resourceName string
param location string = resourceGroup().location
param managedEnvironmentId string

param containerPort int
param useExternalIngress bool = false

param userAssignedIdentityId string = ''

@minLength(1)
param containers array

@minValue(1)
param minReplicas int = 1

@minValue(1)
param maxReplicas int = 10

var containerArrayForConfiguration = [
  for container in containers: {
    name: container.container_name
    image: container.image_name
    env: container.?environment_vars ?? []
    resources: {
      cpu: container.?cpu ?? '1.0'
      memory: container.?memory ?? '2Gi'
    }
  }
]

resource containerApp 'Microsoft.App/containerApps@2025-01-01' = {
  name: resourceName
  location: location
  
  identity: empty(userAssignedIdentityId) ? {
    type: 'SystemAssigned'
  } : {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentityId}': {}
    }
  }

  properties: {
    managedEnvironmentId: managedEnvironmentId
    workloadProfileName: 'Consumption'
    configuration: {
      activeRevisionsMode: 'Single'
      ingress: {
        targetPort: containerPort
        external: useExternalIngress
        allowInsecure: false
        clientCertificateMode: 'ignore'
        transport: 'auto'
        traffic: [
          {
            weight: 100
            latestRevision: true
          }
        ]
      }
    }

    template: {
      containers: containerArrayForConfiguration
      scale: {
        minReplicas: minReplicas
        maxReplicas: maxReplicas
        rules: [
          {
            name: 'http-scaler'
            http: {
              metadata: {
                concurrentRequests: '10'
              }
            }
          }
        ]
      }
    }
  }
}

output resourceId string = containerApp.id
output resourceName string = containerApp.name
