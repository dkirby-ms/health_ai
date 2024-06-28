#!/bin/bash
RG=$1
APIMName=$2
APIPath=$3
APIFormat=$4
ApiUrlPath=$5
subscriptionId=$6

# Get the swagger file
destination="AHDS-Swagger.json"
destinationReplace="AHDS-Swagger-Replace.json"
wget -O $destination $ApiUrlPath

# Replace the placeholder with the service name
# Get the contents of local.ps1 into a string
localContent=$(cat $destination)

# Replace 'XXXXXXXXXXXXXXXXXXXXXXX' with $serviceUrl using sed
modifiedContent=$(echo "$localContent" | sed s#XXXXXXXXXXXXXXXXXXXXXXX#$APIMName#g)

# Save the modified content
echo "$modifiedContent" > $destinationReplace

# Import the API into APIM
az apim api import -g rg-$RG --service-name $APIMName --path $APIPath --specification-format $APIFormat --specification-path $destinationReplace

# Remove temp .env file
rm ./src/web/.env.local