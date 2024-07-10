// Parameters
param workspaceName string
param fhirName string
param location string = resourceGroup().location

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticWorkspaceId string

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'FHIRAuditlogs'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param diagnosticMetricsToEnable array = [
  'AllMetrics'
]

@description('Optional. The name of the diagnostic setting, if deployed.')
param diagnosticSettingsName string = '${fhirName}-diagnosticSettings-001'

param storageAccountName string

// Storage Blob Data Contributor
param roleDefinitionResourceName string = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'


// Variables
var diagnosticsLogsSpecified = [for category in filter(diagnosticLogCategoriesToEnable, item => item != 'allLogs'): {
  category: category
  enabled: true
  retentionPolicy: {
    enabled: false
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsLogs = contains(diagnosticLogCategoriesToEnable, 'allLogs') ? [
  {
    categoryGroup: 'allLogs'
    enabled: true
    retentionPolicy: {
      enabled: false
      days: diagnosticLogsRetentionInDays
    }
  }
] : diagnosticsLogsSpecified

var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: false
    days: diagnosticLogsRetentionInDays
  }
}]

var tenantId = subscription().tenantId
var fhirservicename = '${workspaceName}/${fhirName}'
var loginURL = environment().authentication.loginEndpoint
var authority = '${loginURL}${tenantId}'
var audience = 'https://${workspaceName}-${fhirName}.fhir.azurehealthcareapis.com'
var serviceHost = '${workspaceName}-${fhirName}.fhir.azurehealthcareapis.com'

// Creating FHIR Workspace
resource Workspace 'Microsoft.HealthcareApis/workspaces@2022-06-01' = {
  name: workspaceName
  location: location
  properties: {
    publicNetworkAccess: 'Disabled'
  }
}

// Creating FHIR service at Workspace
resource FHIR 'Microsoft.HealthcareApis/workspaces/fhirservices@2021-11-01' = {
  name: fhirservicename
  location: location
  kind: 'fhir-R4'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    accessPolicies: []
    authenticationConfiguration: {
      authority: authority
      audience: audience
      smartProxyEnabled: false
    }
    publicNetworkAccess: 'Disabled'
    }
    dependsOn: [
      Workspace
    ]
}

// Defining FHIR Diagnostic Settings
resource FHIR_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = {
  name: diagnosticSettingsName
  properties: {
    workspaceId: diagnosticWorkspaceId
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: FHIR
}

// Storage account settings
resource fhirsa 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: storageAccountName
}

// Storage Blob Data Contributor role definition
@description('This is the built-in role definition for Storage Blob Data Contributor')
resource fhirrole 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  name: roleDefinitionResourceName
}

var principalId = FHIR.identity.principalId
var roleDefinitionId = fhirrole.id

// Assigning Storage Blob Data Contributor role to FHIR service
resource fhirroleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, FHIR.name, roleDefinitionId)
  properties: {
    principalId: principalId
    roleDefinitionId: roleDefinitionId
  }
  scope: fhirsa
}

// Outputs
output fhirServiceURL string = audience
output fhirID string = FHIR.id
output fhirWorkspaceID string = Workspace.id
output serviceHost string = serviceHost
