param clustername string
param dnsPrefix string = '${clustername}-dns'
param agentVMSize string
param username string
@secure()
param adminpassword string
param vnetsubnetid string
param count int



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
    nodeResourceGroup: 'rg-nodes-${clustername}'
    kubernetesVersion: '1.25.6'
    dnsPrefix: dnsPrefix
    enableRBAC: true

    agentPoolProfiles:[
      {
        name: 'win'
        osDiskSizeGB: 128
        count: count
        vmSize: agentVMSize
        osType: 'Windows'
        osSKU:'Windows2019'
        mode: 'User'
        osDiskType: 'Managed'
        maxPods: 110
        type:'VirtualMachineScaleSets'
        minCount:2
        maxCount:3
        nodeTaints: [
          'runTime=windows:NoSchedule'
        ]
        powerState:{
          code:'Running'
        }
        nodeLabels:{
          mode: 'System'
          osType: 'Windows'
        }
        vnetSubnetID: vnetsubnetid
        enableAutoScaling:true
      }
      {
        name: 'linux'
        count: count
        vmSize: agentVMSize
        mode: 'System'
        osDiskSizeGB: 128
        osDiskType: 'Managed'
        maxPods: 110
        type:'VirtualMachineScaleSets'
        minCount:2
        maxCount:3
        vnetSubnetID: vnetsubnetid
        osType: 'Linux'
        powerState:{
           code: 'Running'
        }
        nodeLabels: {
          mode: 'System'
          osType: 'Linux'
        }
        enableAutoScaling:true
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

output clusterPrincipalID string = aks.properties.identityProfile.kubeletidentity.objectId
