@description('The virtual network name')
param vnetName string
@description('The name of the subnet')
param subnetName string
@description('The virtual network address prefixes')
param vnetAddressPrefixes array
@description('The subnet address prefix')
param subnetAddressPrefix string

module vnet 'vnet.bicep' = {
  name: 'vnet-deployment'
  params: {
    subnetAddressPrefix: subnetAddressPrefix
    subnetName: subnetName
    vnetAddressPrefixes: vnetAddressPrefixes
    vnetName: vnetName
  }
}
