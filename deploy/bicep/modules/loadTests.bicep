param location string
param name string

resource load 'Microsoft.LoadTestService/loadTests@2021-12-01-preview' = {
  name: name
  location: location
}
