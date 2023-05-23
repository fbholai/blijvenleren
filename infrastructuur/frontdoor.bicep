param frontDoorProfilename string
param frontDoorEndpointname string

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
