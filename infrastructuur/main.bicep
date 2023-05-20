@description('The virtual network name')
param vnetName string
@description('The name of the subnet')
param subnetName string
@description('The virtual network address prefixes')
param vnetAddressPrefixes array
@description('The subnet address prefix')
param subnetAddressPrefix string
param clustername string = 'aks-blijvenleren'
param dnsPrefix string = '${clustername}-dns'


resource keyvault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: 'IBIS-WE-T-AVD-KV2'
}
module vnet 'vnet.bicep' = {
  name: 'vnet-deployment'
  params: {
    subnetAddressPrefix: subnetAddressPrefix
    subnetName: subnetName
    vnetAddressPrefixes: vnetAddressPrefixes
    vnetName: vnetName
  }
}

module aks 'aks-cluster.bicep' = {
  name: 'aks-deployment'
  params: {
    dnsPrefix: dnsPrefix
    adminpassword: keyvault.getSecret('aksadminpassword')
    agentVMSize: 'standard_d2s_v3'
    clustername: 'aks-blijvenleren'
    osdisksize: 128
    username: 'azureuser'
    vnetsubnetid: vnet.outputs.subnetId
  }
}
