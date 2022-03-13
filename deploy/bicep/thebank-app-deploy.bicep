var location = 'northeurope'
var containerAppsEnv = 'app-env-001'
var containerRegistry = 'acrbicepreg01.azurecr.io'
var containerRegistryUsername = 'acrbicepreg01'

@secure()
param containerRegistryPassword string

module containerAppsEnvModule 'modules/container-apps/thebank.bicep' = {
  name: '${deployment().name}-containerAppsEnv'
  params: {
    location: location
    containerAppsEnvName: containerAppsEnv
    containerRegistry: containerRegistry
    containerRegistryUsername: containerRegistryUsername
    containerRegistryPassword: containerRegistryPassword
  }
}
