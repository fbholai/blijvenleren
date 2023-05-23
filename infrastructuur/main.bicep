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
param subnetNamegw string
param vnetAddressPrefixesgw string
param frontDoorProfilename string
param frontDoorEndpointname string

resource keyvault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: 'IBIS-WE-T-AVD-KV2'
  scope: resourceGroup('IBIS-WE-P-RG-AVD-KEYVAULT')
}
module vnet 'vnet.bicep' = {
  name: 'vnet-deployment'
  params: {
    subnetNamegw: subnetNamegw
    vnetAddressPrefixesgw: vnetAddressPrefixesgw
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
    adminpassword: keyvault.getSecret('aksadminpass')
    agentVMSize: agentVMSize
    clustername: clustername
    username: username
    vnetsubnetid: vnet.outputs.subnetId
  }
  dependsOn:[
    vnet
  ]
}

module frontdoor 'frontdoor.bicep' = {
  name: 'afd-deployment'
  params: {
    frontDoorEndpointname: frontDoorEndpointname
    frontDoorProfilename: frontDoorProfilename
  }
}
