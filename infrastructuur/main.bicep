@description('The virtual network name')
param vnetName string
@description('The name of the subnet')
param subnetName string
@description('The virtual network address prefixes')
param vnetAddressPrefixes array
@description('The subnet address prefix')
param subnetAddressPrefix string
param clustername string
param dnsPrefix string = '${clustername}-dns'
param agentVMSize string
param username string
param count int


resource keyvault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: 'IBIS-WE-T-AVD-KV2'
  scope: resourceGroup('IBIS-WE-P-RG-AVD-KEYVAULT')
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
    count: count
    dnsPrefix: dnsPrefix
    adminpassword: 'Esdfsfsfsd!erD5'
    agentVMSize: agentVMSize
    clustername: clustername
    username: username
    vnetsubnetid: vnet.outputs.subnetId
  }
  dependsOn:[
    vnet
  ]
}
