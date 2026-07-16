<#
Project: azure-synapse-serverless-serving-layer
Script: grant_synapse_storage_reader.ps1
Purpose: Grant the Synapse workspace managed identity read access to the storage account.

This script assigns Storage Blob Data Reader at the storage account scope.
Run only if you plan to use Managed Identity in the external data source.

Prerequisites:
- az login
- Permission to assign RBAC roles on the storage account
- Existing Synapse workspace
- Existing ADLS Gen2 storage account
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$SynapseWorkspaceName,

    [Parameter(Mandatory = $true)]
    [string]$StorageAccountName
)

$ErrorActionPreference = "Stop"

Write-Host "Reading Synapse workspace managed identity..." -ForegroundColor Cyan
$workspacePrincipalId = az synapse workspace show `
    --resource-group $ResourceGroupName `
    --name $SynapseWorkspaceName `
    --query identity.principalId `
    --output tsv

if ([string]::IsNullOrWhiteSpace($workspacePrincipalId)) {
    throw "Could not find a system-assigned managed identity principalId for the Synapse workspace."
}

Write-Host "Reading storage account scope..." -ForegroundColor Cyan
$storageScope = az storage account show `
    --resource-group $ResourceGroupName `
    --name $StorageAccountName `
    --query id `
    --output tsv

if ([string]::IsNullOrWhiteSpace($storageScope)) {
    throw "Could not find storage account scope."
}

Write-Host "Assigning Storage Blob Data Reader..." -ForegroundColor Cyan
az role assignment create `
    --assignee-object-id $workspacePrincipalId `
    --assignee-principal-type ServicePrincipal `
    --role "Storage Blob Data Reader" `
    --scope $storageScope

Write-Host "Role assignment requested successfully." -ForegroundColor Green
Write-Host "Note: RBAC propagation can take a few minutes before Synapse can read the files." -ForegroundColor Yellow
