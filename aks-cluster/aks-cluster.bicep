param environmentName string
var vnetName = 'vnet-blijvenleren-${environmentName}'
param vnetAddressPrefixes array
param subnetNameCluster string
param clusterSubnetPrefix string
param subnetNameGateway string
param gatewaySubnetPrefix string
param nsgId string
param subnetNameVirtualNodes string
param virtualNodesSubnetPrefix string
param location string  = resourceGroup().location


resource vnet 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace:{
      addressPrefixes: vnetAddressPrefixes 
    }
    subnets: [
      {
        name: subnetNameCluster
        properties:{
          addressPrefix:clusterSubnetPrefix
        }
      }
      {
        name: subnetNameGateway
        properties:{
          addressPrefix:gatewaySubnetPrefix
          networkSecurityGroup: {
            id: nsgId
          }
        }
      }
      {
        name:subnetNameVirtualNodes
        properties:{
          addressPrefix:virtualNodesSubnetPrefix
        }
      }
    ]
  }
}
