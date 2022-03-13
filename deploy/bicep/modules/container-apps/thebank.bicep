param containerAppsEnvName string
param location string
param containerRegistry string
param containerRegistryUsername string

@secure()
param containerRegistryPassword string

var containerRegistryPasswordRef = 'container-registry-password'

resource acaEnv 'Microsoft.App/managedEnvironments@2022-01-01-preview' existing = {
  name: containerAppsEnvName
}

resource thebank 'Microsoft.App/containerApps@2022-01-01-preview' = {
  name: 'thebank'
  location: location
  properties: {
    managedEnvironmentId: acaEnv.id
    template: {
      containers: [
        {
          name: 'thebank'
          image: 'acrbicepreg01.azurecr.io/thebank:main-cee7680e-1646161150'
          resources: {
            cpu: json('0.25')
            memory: '.5Gi'
          }
          env: [
            {
              name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
              value: 'ffc09cbe-a704-4a55-acae-a5dfb5fcfad8'
            }
          ]
        }
      ]
      scale: {
        minReplicas: 2
        maxReplicas: 10
        rules: [
          {
            name: 'http-rule'
            http: {
              metadata: {
                concurrentRequests: '100'
              }
            }
          }
        ]
      }
    }
    configuration: {
      secrets: [
        {
          name: containerRegistryPasswordRef
          value: containerRegistryPassword
        }
      ]
      registries: [
        {
          server: containerRegistry
          username: containerRegistryUsername
          passwordSecretRef: containerRegistryPasswordRef
        }
      ]
      ingress: {
        external: true
        targetPort: 80
      }
    }
  }
}
