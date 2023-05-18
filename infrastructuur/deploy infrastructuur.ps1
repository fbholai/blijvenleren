az deployment group create `
  --name 'vnet deployment' `
  --resource-group 'blijvenleren' `
  --template-file '.\main.bicep' `
  --parameters '.\main.parameters.json'