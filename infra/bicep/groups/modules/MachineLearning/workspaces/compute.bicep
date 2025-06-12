
param resourceName string
param mlStudioResourceName string

@description('The name of the Azure Machine Learning workspace to which the compute will be added.')
@minValue(1)
param maxNodeCount int = 4

@description('The name of the Azure Machine Learning workspace to which the compute will be added.')
param minNodeCount int = 0

@description('The name of the Azure Machine Learning workspace to which the compute will be added.')
@allowed(['Dedicated', 'LowPriority'])
param vmPriority string = 'Dedicated'

@description('The name of the Azure Machine Learning workspace to which the compute will be added.')
param vmSize string = 'STANDARD_DS11_V2'

resource mlWorkspace 'Microsoft.MachineLearningServices/workspaces@2023-04-01' existing = {
  name: mlStudioResourceName
}

resource compute 'Microsoft.MachineLearningServices/workspaces/computes@2023-04-01' = {
  name: resourceName
  location: resourceGroup().location
  parent: mlWorkspace
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    computeType: 'AmlCompute'
    properties: {
      scaleSettings: {
        maxNodeCount: maxNodeCount
        minNodeCount: minNodeCount
        nodeIdleTimeBeforeScaleDown: 'PT5M'
      }
      vmPriority: vmPriority
      vmSize: vmSize
    }
  }
}
