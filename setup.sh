set -a            
source .settings
set +a

az login --tenant $tenant 
az account set --subscription $subscription

az group create --name $resource_group_name --location $region

current_user=$(az ad signed-in-user show --query userPrincipalName | tr -d '"')

# Create the smallest available Fabric SKU for testing
az fabric capacity create \
    --resource-group $resource_group_name \
    --capacity-name $capacity_name \
    --administration "{members:[$current_user]}" \
    --sku "{name:F2,tier:Fabric}" \
    --location $region

# At the time of writing there is no Fabric CLI. 
# Configuring Fabric via the REST API

fabric_scope=https://api.fabric.microsoft.com/.default
fabric_token=$(az account get-access-token --scope $fabric_scope --query accessToken | tr -d '"')

workspace1_name=ws1
workspace2_name=ws2
lakehouse1_name=ws1_lakehouse
lakehouse2_name=ws2_lakehouse

# Get fabric capacity id
capacity_id=$(curl -H 'Content-Type: application/json' \
        -H "Authorization: Bearer $fabric_token" \
        -X GET \
        https://api.fabric.microsoft.com/v1/capacities \
        | jq ".value[] | select(.displayName==\"$capacity_name\") | .id" | tr -d '"')

# Create two workspaces
workspace1_id=$(curl -H 'Content-Type: application/json' \
        -H "Authorization: Bearer $fabric_token" \
        -d "{ \"displayName\": \"$workspace1_name\" }" \
        -X POST \
        https://api.fabric.microsoft.com/v1/workspaces \
        | jq '.id' | tr -d '"')

workspace2_id=$(curl -H 'Content-Type: application/json' \
        -H "Authorization: Bearer $fabric_token" \
        -d "{ \"displayName\": \"$workspace2_name\" }" \
        -X POST \
        https://api.fabric.microsoft.com/v1/workspaces \
        | jq '.id' | tr -d '"')

# Assign the workspaces to the fabric capacity
curl -H 'Content-Type: application/json' \
     -H "Authorization: Bearer $fabric_token" \
     -d "{\"capacityId\": \"$capacity_id\"}" \
     -X POST \
     https://api.fabric.microsoft.com/v1/workspaces/$workspace1_id/assignToCapacity

curl -H 'Content-Type: application/json' \
     -H "Authorization: Bearer $fabric_token" \
     -d "{\"capacityId\": \"$capacity_id\"}" \
     -X POST \
     https://api.fabric.microsoft.com/v1/workspaces/$workspace2_id/assignToCapacity

# Create lakehouses
curl -H 'Content-Type: application/json' \
     -H "Authorization: Bearer $fabric_token" \
     -d "{\"displayName\": \"$lakehouse1_name\"}" \
     -X POST \
     https://api.fabric.microsoft.com/v1/workspaces/$workspace1_id/lakehouses

curl -H 'Content-Type: application/json' \
     -H "Authorization: Bearer $fabric_token" \
     -d "{\"displayName\": \"$lakehouse2_name\"}" \
     -X POST \
     https://api.fabric.microsoft.com/v1/workspaces/$workspace2_id/lakehouses


### Cleanup workspaces
curl -H 'Content-Type: application/json' \
     -H "Authorization: Bearer $fabric_token" \
     -X DELETE \
     https://api.fabric.microsoft.com/v1/workspaces/$workspace1_id

curl -H 'Content-Type: application/json' \
     -H "Authorization: Bearer $fabric_token" \
     -X DELETE \
     https://api.fabric.microsoft.com/v1/workspaces/$workspace2_id

curl -H 'Content-Type: application/json' \
     -H "Authorization: Bearer $fabric_token" \
     -X GET \
     https://api.fabric.microsoft.com/v1/workspaces
