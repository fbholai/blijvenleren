az deployment mg create `
  --name 'storagepolicy' `
  --location 'westeurope' `
  --management-group-id 'IBIS-AVD-TEST' `
  --template-file '.\main.bicep' `
  --parameters '.\main.parameters.json'