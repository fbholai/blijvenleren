targetScope = 'managementGroup'
param policyName string
param displaynamepolicydefinition string
param region string
param descriptionpolicydefinition string
param displaynamepolicyassignment string
param descriptionpolicyassignment string
param policydefinitionID string

module azurepolicy 'azurepolicySA.bicep' = {
  name: 'deploy-policy'
  params: {
    descriptionpolicyassignment: descriptionpolicyassignment
    descriptionpolicydefinition: descriptionpolicydefinition
    displaynamepolicyassignment: displaynamepolicyassignment
    displaynamepolicydefinition: displaynamepolicydefinition
    policydefinitionID: policydefinitionID
    policyName: policyName
    region: region
  }
  scope: managementGroup()
}
