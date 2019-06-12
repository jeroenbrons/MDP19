az group create --name ETEQ --location "East US"
az appservice plan create --name ETEQplan --resource-group ETEQ --sku FREE --is-linux
az webapp create --plan ETEQplan --resource-group ETEQ --name odooETEQHU --multicontainer-config-type compose --multicontainer-config-type compose --multicontainer-config-file odoo2.yml
#az webapp config container set --resource-group ETEQ --name odooETEQHU --multicontainer-config-type compose --multicontainer-config-file odoo2.yml