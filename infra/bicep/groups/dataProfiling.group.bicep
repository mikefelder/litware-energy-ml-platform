
param location string = resourceGroup().location

module naming 'modules/naming.bicep' = {
  name: 'naming'
}

var locationShorthand = naming.outputs.locationShorthand[location]

module dataFactory 'modules/DataFactory/factories.bicep' = {
  name: 'dataFactory-dataprofiling-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.dataFactory.prefix}-genaifieldops-${locationShorthand}'
    location: location
  }
}

module failedPipelinesMericAlert 'modules/Insights/metricAlerts.bicep' = {
  name: 'dataFactoryFailedPipelinesMetricAlert-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.metricAlert.prefix}-dataprofiling-failed-pipelines'
    location: location
    targetResourceId: dataFactory.outputs.resourceId
    criteriaBlock: {
      '@odata.type': '#Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          name: 'PipelineFailedRuns'
          metricName: 'FailedPipelineRuns'
          metricNamespace: 'Microsoft.DataFactory/factories'
          operator: 'GreaterThan'
          threshold: 0
          timeAggregation: 'Total'
          criterionType: 'StaticThresholdCriterion'
        }
      ]
    }
  }
}

module workspaceAnalytics 'modules/OperationalInsights/workspaces.bicep' = {
  name: 'workspace-dataprofiling-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.logAnalytics.prefix}-dataprofiling-${locationShorthand}'
    location: location
  }
}

module appInsights 'modules/Insights/components.bicep' = {
  name: 'appinsights-dataprofiling-deployment'
  params: {
    resourceName: '${naming.outputs.resourceNaming.appInsights.prefix}-dataprofiling-${locationShorthand}'
    workspaceId: workspaceAnalytics.outputs.resourceId
    location: location
  }
}
