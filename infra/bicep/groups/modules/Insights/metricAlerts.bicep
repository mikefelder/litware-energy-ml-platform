
param resourceName string
param location string = resourceGroup().location
param targetResourceId string

@minValue(1)
@maxValue(5)
param severityLevel int = 3

param enabled bool = true
param evaluationFrequency string = 'PT5M'
param windowSize string = 'PT5M'

param criteriaBlock object

resource metricAlerts 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: resourceName
  location: location
  properties: {
    description: 'Metric alert for ${last(split(targetResourceId, '/'))}'
    severity: severityLevel
    enabled: enabled
    scopes: [
      targetResourceId
    ]
    evaluationFrequency: evaluationFrequency
    windowSize: windowSize
    criteria: criteriaBlock
    autoMitigate: true
  }
}
