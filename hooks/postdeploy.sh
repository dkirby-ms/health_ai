#!/bin/bash
RG=$1
APIMName=$2
APIPath=$3
APIFormat=$4
ApiUrlPath=$5
subscriptionId=$6
fhirHost=$7
StorageName=$8
WorkspaceID=$9
FhirID=${10}
TenantID=${11}


# Get the swagger file
destination="AHDS-Swagger.json"
destinationReplace="AHDS-Swagger-Replace.json"
wget -O $destination $ApiUrlPath

# Replace the placeholder with the service name
# Get the contents of local.ps1 into a string
localContent=$(cat $destination)

# Replace 'XXXXXXXXXXXXXXXXXXXXXXX' with $serviceUrl using sed
modifiedContent=$(echo "$localContent" | sed s#XXXXXXXXXXXXXXXXXXXXXXX#$fhirHost#g)

# Save the modified content
echo "$modifiedContent" > $destinationReplace

# Import the API into APIM
az apim api import -g $RG --service-name $APIMName --path $APIPath --specification-format $APIFormat --specification-path $destinationReplace

# Update storage account's NetworkACLs to allow access from FHIR service
echo "Updating NACLs: ${WorkspaceID} ${FhirID} ${RG} ${StorageName} ${TenantID}"
az storage account network-rule add --resource-id $WorkspaceID -g $RG --account-name $StorageName --tenant-id $TenantID
az storage account network-rule add --resource-id $FhirID -g $RG --account-name $StorageName --tenant-id $TenantID

# Remove temp .env file
rm ./src/web/.env.local
