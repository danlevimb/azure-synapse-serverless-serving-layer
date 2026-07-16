<#
.SYNOPSIS
Uploads the generated curated Parquet sample data to ADLS Gen2 for the
azure-synapse-serverless-serving-layer project.

.DESCRIPTION
This script uploads local Parquet files from:

  sample_data/generated/curated/

to the ADLS Gen2 container path:

  <container>/curated/

It uses Azure CLI with interactive login / Microsoft Entra authentication.
No storage keys, SAS tokens, or connection strings should be placed in this script.

.EXAMPLE
.\scripts\upload_sample_data_to_adls.ps1 `
  -StorageAccountName "stsynservdevmxc001" `
  -ContainerName "synapse-serving"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$StorageAccountName,

    [Parameter(Mandatory = $false)]
    [string]$ContainerName = "synapse-serving",

    [Parameter(Mandatory = $false)]
    [string]$LocalCuratedRoot = "sample_data/generated/curated"
)

$ErrorActionPreference = "Stop"

Write-Host "Azure Synapse Serving Layer - ADLS Upload" -ForegroundColor Cyan
Write-Host "Storage account: $StorageAccountName"
Write-Host "Container:       $ContainerName"
Write-Host "Local source:    $LocalCuratedRoot"
Write-Host "Destination:     curated/"
Write-Host ""

if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    throw "Azure CLI was not found. Install Azure CLI and run 'az login' before executing this script."
}

if (-not (Test-Path $LocalCuratedRoot)) {
    throw "Local curated root not found: $LocalCuratedRoot. Run scripts/generate_sample_data.py first."
}

Write-Host "Checking Azure CLI login..." -ForegroundColor Yellow
az account show --output none

Write-Host "Creating container if it does not exist..." -ForegroundColor Yellow
az storage container create `
    --account-name $StorageAccountName `
    --name $ContainerName `
    --auth-mode login `
    --output table

Write-Host "Uploading curated Parquet files..." -ForegroundColor Yellow
az storage blob upload-batch `
    --account-name $StorageAccountName `
    --destination $ContainerName `
    --source $LocalCuratedRoot `
    --destination-path "curated" `
    --auth-mode login `
    --overwrite true `
    --output table

Write-Host "Listing uploaded curated retail files..." -ForegroundColor Yellow
az storage blob list `
    --account-name $StorageAccountName `
    --container-name $ContainerName `
    --prefix "curated/retail/" `
    --auth-mode login `
    --output table

Write-Host ""
Write-Host "Upload completed. Expected ADLS paths:" -ForegroundColor Green
Write-Host "  curated/retail/customers/customers.parquet"
Write-Host "  curated/retail/products/products.parquet"
Write-Host "  curated/retail/orders/orders.parquet"
Write-Host "  curated/retail/order_items/order_items.parquet"
Write-Host ""
Write-Host "Status: PASS" -ForegroundColor Green
