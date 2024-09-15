set -a            
source .settings
set +a

az login --tenant $tenant 
az account set --subscription $subscription

az group delete --name $resource_group_name --yes

## Fabric resources are deleted at the end of the setup script.