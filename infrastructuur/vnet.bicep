@description('The virtual network name')
param vnetName string
@description('The name of the subnet')
param subnetName string
@description('The virtual network address prefixes')
param vnetAddressPrefixes array
@description('The subnet address prefix')
param subnetAddressPrefix string


resource vnet 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnetName
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressPrefixes
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
        }
      }      
    ]
  }
}
 
output subnetId string = '${vnet.id}/subnets/${subnetName}'

