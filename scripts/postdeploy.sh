#!/bin/bash
APIMName=$1
serviceUrl=$2
APIPath=$3
APIFormat=$4
ApiUrlPath=$5
subscriptionId=$6

# Get the swagger file
ApiUrlPath="https://raw.githubusercontent.com/dkirby-ms/health_ai/main/infra/app/apim/AHDS-Swagger.json"
destination="AHDS-Swagger.json"
destinationReplace="AHDS-Swagger-Replace.json"
serviceUrl="https://aka.ms"
wget -O $destination $ApiUrlPath

# Replace the placeholder with the service name
# Get the contents of local.ps1 into a string
localContent=$(cat $destination)

# Replace 'XXXXXXXXXXXXXXXXXXXXXXX' with $serviceUrl using sed
modifiedContent=$(echo "$localContent" | sed s#XXXXXXXXXXXXXXXXXXXXXXX#$serviceUrl#g)

# Save the modified content
echo "$modifiedContent" > $destinationReplace

# Remove temp .env file
rm ./src/web/.env.local