targetScope = 'subscription'

param location string = 'northeurope'
param containerAppsEnvName string = 'app-env-001'
param logAnalyticsWorkspaceName string = 'law-app-env-001'
param appInsightsName string = 'ai-thebank-001'
param loadTestLocation1 string = 'eastus'
param loadTestLocation2 string = 'australiaeast'
param resourceGroupName string = 'rg-container-apps-load-test-01'

module resourceGroupModule 'modules/resource-group.bicep' = {
  name: '${deployment().name}-resourceGroup'
  scope: subscription()
  params: {
    location: location
    resourceGroupName: resourceGroupName
  }
}

module containerAppsEnvModule 'modules/aca-env.bicep' = {
  name: '${deployment().name}-containerAppsEnv'
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    resourceGroupModule
  ]
  params: {
    location: location
    containerAppsEnvName: containerAppsEnvName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    appInsightsName: appInsightsName
  }
}

module loadTestModule1 'modules/loadTests.bicep' = {
  name: '${deployment().name}-load-test-us'
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    resourceGroupModule
  ]
  params: {
    location: loadTestLocation1
    name: 'load-test-${loadTestLocation1}'
  }
}

module loadTestModule2 'modules/loadTests.bicep' = {
  name: '${deployment().name}-load-test-australia'
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    resourceGroupModule
  ]
  params: {
    location: loadTestLocation2
    name: 'load-test-${loadTestLocation2}'
  }
}
