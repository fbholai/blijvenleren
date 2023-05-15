targetScope = 'managementGroup'
//Parameter definitions
param policyName string
param displaynamepolicydefinition string
param region string
param descriptionpolicydefinition string
param displaynamepolicyassignment string
param descriptionpolicyassignment string
param policydefinitionID string

//Create policydefinition
resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: policyName
  properties: {
    displayName: displaynamepolicydefinition
    policyType: 'Custom'
    mode: 'All'
    parameters: {
      listOfResourceTypesAllowed:{
        type: 'Array'
        allowedValues:[
          region
        ]
        
      }
    }
      

    description: descriptionpolicydefinition
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Storage/storageAccounts'
          }
          {
            field: 'location'
            notIn: '[parameters(\'listOfResourceTypesAllowed\')]'
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

//create policyassignment
resource policyassignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: policyName
  scope: managementGroup()
  properties:{
    parameters:{
      listOfResourceTypesAllowed: {
        value: [region]
      }
    }
    description:descriptionpolicyassignment
    displayName: displaynamepolicyassignment
    enforcementMode: 'Default'
    policyDefinitionId: policydefinitionID
  }
}
