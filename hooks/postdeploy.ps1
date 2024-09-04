param(
      [string] [Parameter(Mandatory=$true)] $RG,
      [string] [Parameter(Mandatory=$true)] $APIMName,
      [string] [Parameter(Mandatory=$true)] $APIPath,
      [string] [Parameter(Mandatory=$true)] $APIFormat,
      [string] [Parameter(Mandatory=$true)] $ApiUrlPath,
      [string] [Parameter(Mandatory=$true)] $subscriptionId,
      [string] [Parameter(Mandatory=$true)] $fhirHost,
      [string] [Parameter(Mandatory=$true)] $storageAccount,
      [string] [Parameter(Mandatory=$true)] $workspaceID,
      [string] [Parameter(Mandatory=$true)] $fhirID,
      [string] [Parameter(Mandatory=$true)] $tenantID
      )

      $ErrorActionPreference = 'Stop'
      $destination = 'AHDS-Swagger.json'
      $destinationReplace = 'AHDS-Swagger-Replace.json'
      try {
          Invoke-RestMethod -Uri $ApiUrlPath -OutFile $destination -StatusCodeVariable result
      }
      catch {
          Write-Error "Unable to download $ApiUrlPath. Error: $($Error[0])"
          throw
      }
      ((Get-Content -path $destination -Raw) -replace 'XXXXXXXXXXXXXXXXXXXXXXX',$fhirHost) | Set-Content -Path $destinationReplace
      #az apim api import -g $RG --service-name $APIMName --path $APIPath --specification-format $APIFormat --specification-path $destinationReplace

      # Get context of the API Management instance.
      $context = New-AzApiManagementContext -ResourceGroupName $RG -ServiceName $APIMName

      # Import API
      Import-AzApiManagementApi -Context $context -SpecificationFormat $APIFormat -SpecificationPath $destinationReplace -Path $APIPath

      # Update Storage Account Network ACLs
      Update-AzStorageAccountNetworkRuleSet -ResourceGroupName $RG -Name $storageAccount -ResourceAccessRule (@{ResourceId=$workspaceID;TenantId=$tenantId},@{ResourceId=$fhirID;TenantId=$tenantId})
      
      Remove-Item -Path ".\src\web\.env.local" -Force
