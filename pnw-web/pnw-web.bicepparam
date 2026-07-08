using './pnw-web.bicep'

param location = 'westeurope'

param webResourceGroupName = 'pnw-web'

param networkResourceGroupName = 'prd-network'
param virtualNetworkName = 'ntwp1hub01vnet01'
param privateEndpointSubnetName = 'webp1pnw01lan01'

param privateDnsZoneResourceGroupName = 'prd-network'
param privateDnsZoneName = 'privatelink.azurewebsites.net'

param appServicePlanName = 'ntwp1web01asp01'
param appServiceName = 'ntwp1web01as01'
param privateEndpointName = 'ntwp1web01as01pe01'
