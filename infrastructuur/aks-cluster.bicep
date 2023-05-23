param clustername string
param dnsPrefix string = '${clustername}-dns'
param agentVMSize string
param username string
@secure()
param adminpassword string
param vnetsubnetid string
param count int
param frontDoorProfilename string
param frontDoorEndpointname string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: 'LAW-${clustername}'
  location: resourceGroup().location
  properties: {
    sku: {
      name:'PerGB2018'
    }
  }
}

resource azmonitorworkspace 'Microsoft.Monitor/accounts@2023-04-03' ={
  name: 'aks-monitor-workspace'
  location: resourceGroup().location
}


resource aksgrafana 'Microsoft.Dashboard/grafana@2022-08-01' = {
  name: 'aksgrafanadashboard'
  location:resourceGroup().location
  sku:{
    name: 'Standard'
  }
  identity:{
    type: 'SystemAssigned'
  }
  properties:{
    grafanaIntegrations:{
      azureMonitorWorkspaceIntegrations:[
        {
          azureMonitorWorkspaceResourceId: azmonitorworkspace.id
        }
      ]
    }
  }
  dependsOn:[
    azmonitorworkspace
  ]

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
    addonProfiles:{
      omsagent:{
        enabled: true
        config:{
          logAnalyticsWorkspaceResourceID: logAnalyticsWorkspace.id
        }
      }
    }
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
        minCount:3
        maxCount:5
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
        minCount:3
        maxCount:5
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

resource frontDoorProfile 'Microsoft.Cdn/profiles@2021-06-01' = {
  name: frontDoorProfilename
  location: 'global'
  sku: {
    name:'Standard_AzureFrontDoor'
  }
}

resource frontDoorEndpoint 'Microsoft.Cdn/profiles/afdEndpoints@2021-06-01' = {
  name: frontDoorEndpointname
  location: 'global'
  parent: frontDoorProfile
  properties:{
    enabledState: 'Enabled'
  }
}

resource frontDoorOriginGroup 'Microsoft.Cdn/profiles/originGroups@2021-06-01' = {
  name: 'aks-origin'
  parent:frontDoorProfile
  properties: {
    loadBalancingSettings: {
    sampleSize: 4
    successfulSamplesRequired: 3
    additionalLatencyInMilliseconds:50
  }
  healthProbeSettings:{
    probePath:'/'
    probeProtocol:'Http'
    probeIntervalInSeconds:100
    probeRequestType:'HEAD'
  }
}}
resource publicip 'Microsoft.Network/publicIPAddresses@2022-11-01' existing = {
  name: 'kubernetes-aae1aab1c75554a48b9a6025cd814441'
  scope: resourceGroup('rg-nodes-aks-blijvenleren')
}
resource frontDoorOrigin 'Microsoft.Cdn/profiles/originGroups/origins@2021-06-01' = {
  name: 'westeurope'
  parent:frontDoorOriginGroup
  properties:{
    originHostHeader: publicip.properties.ipAddress
    hostName: publicip.properties.ipAddress
    enabledState:'Enabled'
    httpPort:80
    httpsPort:443
    priority:1
    weight:1000
    enforceCertificateNameCheck:false
  }
}

resource frontDoorRoute 'Microsoft.Cdn/profiles/afdEndpoints/routes@2021-06-01' ={
  name: 'aks-route'
  parent:frontDoorEndpoint
  dependsOn:[
    frontDoorOrigin
  ]
  properties:{
    linkToDefaultDomain:'Enabled'
    supportedProtocols:[
      'Http'
      'Https'
    ]
    originGroup:{
      id:frontDoorOriginGroup.id
    }
    forwardingProtocol:'HttpOnly'
    patternsToMatch:[
      '/*'
    ]
    httpsRedirect:'Enabled'
    enabledState:'Enabled'

  }
}
