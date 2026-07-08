targetScope = 'subscription'

@description('Azure region for the pnw-web workload.')
param location string

@description('Name of the pnw-web resource group.')
param webResourceGroupName string

@description('Name of the existing network resource group.')
param networkResourceGroupName string

@description('Name of the existing virtual network.')
param virtualNetworkName string

@description('Name of the existing Private Endpoint subnet.')
param privateEndpointSubnetName string

@description('Name of the resource group containing the Private DNS zone.')
param privateDnsZoneResourceGroupName string

@description('Name of the existing App Service Private DNS zone.')
param privateDnsZoneName string

@description('Name of the App Service Plan.')
param appServicePlanName string

@description('Name of the App Service.')
param appServiceName string

@description('Name of the App Service Private Endpoint.')
param privateEndpointName string


var privateEndpointSubnetResourceId = resourceId(
  networkResourceGroupName,
  'Microsoft.Network/virtualNetworks/subnets',
  virtualNetworkName,
  privateEndpointSubnetName
)

var privateDnsZoneResourceId = resourceId(
  privateDnsZoneResourceGroupName,
  'Microsoft.Network/privateDnsZones',
  privateDnsZoneName
)


module webResourceGroup 'br/public:avm/res/resources/resource-group:0.4.3' = {
  name: 'deploy-${webResourceGroupName}'
  params: {
    name: webResourceGroupName
    location: location
  }
}


module appServicePlan 'br/public:avm/res/web/serverfarm:0.7.0' = {
  name: 'deploy-${appServicePlanName}'
  scope: resourceGroup(webResourceGroupName)

  params: {
    name: appServicePlanName
    location: location
    kind: 'linux'
    reserved: true
    skuName: 'B1'
    skuCapacity: 1
  }

  dependsOn: [
    webResourceGroup
  ]
}


module appService 'br/public:avm/res/web/site:0.23.1' = {
  name: 'deploy-${appServiceName}'
  scope: resourceGroup(webResourceGroupName)

  params: {
    name: appServiceName
    location: location
    kind: 'app,linux'
    reserved: true
    serverFarmResourceId: appServicePlan.outputs.resourceId

    httpsOnly: true
    publicNetworkAccess: 'Disabled'

    siteConfig: {
      alwaysOn: true
      linuxFxVersion: 'NODE|24-lts'
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
    }

    privateEndpoints: [
      {
        name: privateEndpointName
        resourceGroupResourceId: webResourceGroup.outputs.resourceId
        subnetResourceId: privateEndpointSubnetResourceId

        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: privateDnsZoneResourceId
            }
          ]
        }
      }
    ]
  }
}


output appServiceName string = appService.outputs.name
output appServiceDefaultHostname string = appService.outputs.defaultHostname
output privateEndpointName string = appService.outputs.privateEndpoints[0].name
