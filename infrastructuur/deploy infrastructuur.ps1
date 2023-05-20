az account set --subscription '98754053-8af8-4e87-b2e5-bd7afb61a868'


az deployment group create `
  --name 'vnet' `
  --resource-group 'blijvenleren' `
  --template-file '.\main.bicep' `
  --parameters '.\main.parameters.json'
