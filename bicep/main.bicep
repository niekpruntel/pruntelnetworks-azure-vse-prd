targetScope = 'subscription'

@description('Name of the resource group for the PruntelNetworks web workload.')
param webResourceGroupName string = 'pnw-web'

@description('Azure region for the PruntelNetworks web workload resource group.')
param location string

resource webResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: webResourceGroupName
  location: location
}
