param clustername string
param dnsPrefix string = '${clustername}-dns'
param osdisksize int
param agentVMSize string
param username string
@secure()
param adminpassword string
param vnetsubnetid string


resource vnet 'Microsoft.Network/virtualNetworks@2019-11-01' existing = {
  name: 'vnet-aks-blijvenleren'
}

resource aks 'Microsoft.ContainerService/managedClusters@2022-05-02-preview' = {
  name: clustername
  location: resourceGroup().location
  sku: {
    name:'Basic'        
    tier:'Free'
  }
  identity: {
   type: 'SystemAssigned' 
  }
  properties:{
    dnsPrefix: dnsPrefix
    agentPoolProfiles:[
      {
        name: 'windows'
        osDiskSizeGB: 128
        count: osdisksize
        vmSize: agentVMSize
        osType: 'Windows'
        osSKU:'Windows2022'
        mode:'System'
        osDiskType: 'Managed'
        maxPods: 110
        type: 'VirtualMachineScaleSets'
        availabilityZones: [
          '1'
          '2'
          '3'
        ]
        nodeTaints: [
          'runTime=windows:NoSchedule'
        ]
        maxCount:3
        minCount:1
        enableAutoScaling: true
        powerState:{
          code:'Running'
        }
        nodeLabels:{
          mode: 'System'
          osType: 'Windows'
        }
        vnetSubnetID: vnetsubnetid
      }
    ]
    networkProfile:{
      networkPlugin: 'azure'
      serviceCidr: '10.0.0.0/16'
      dnsServiceIP: '10.0.0.10'
      dockerBridgeCidr: '172.17.0.1/16'
    }
    windowsProfile:{
      adminUsername: username
      adminPassword: adminpassword
    }
    servicePrincipalProfile:{
      clientId: 'msi'
    }
    storageProfile:{
      diskCSIDriver:{
        enabled: true
      }
      fileCSIDriver:{
        enabled:true
      }
      snapshotController:{
        enabled:true
      }
    }
    autoUpgradeProfile:{
      upgradeChannel:'stable'
    }
  }
}
