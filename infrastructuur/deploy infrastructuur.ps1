az deployment group create `
  --name 'vnet' `
  --resource-group 'blijvenleren' `
  --template-file '.\main.bicep' `
  --parameters '.\main.parameters.json'