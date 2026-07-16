/*
Project: azure-synapse-serverless-serving-layer
Script: 01_create_external_data_source.sql
Purpose: Create the database scoped credential and external data source for ADLS Gen2.

Before running:
1. Replace <storage_account_name> with your ADLS Gen2 storage account name.
2. Replace <replace-with-strong-master-key-password> with a strong password.
3. Grant the Synapse workspace managed identity Storage Blob Data Reader access to the storage account or container.

This script uses the Synapse workspace Managed Identity.
Do not commit real secrets, SAS tokens, storage account keys, or connection strings.
*/

USE [synapse_serving_demo];
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.symmetric_keys
    WHERE name = N'##MS_DatabaseMasterKey##'
)
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = '<replace-with-strong-master-key-password>';
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_scoped_credentials
    WHERE name = N'cred_synapse_workspace_mi'
)
BEGIN
    CREATE DATABASE SCOPED CREDENTIAL [cred_synapse_workspace_mi]
    WITH IDENTITY = 'Managed Identity';
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.external_data_sources
    WHERE name = N'ds_adls_synapse_serving'
)
BEGIN
    CREATE EXTERNAL DATA SOURCE [ds_adls_synapse_serving]
    WITH (
        LOCATION = 'abfss://synapse-serving@<storage_account_name>.dfs.core.windows.net',
        CREDENTIAL = [cred_synapse_workspace_mi]
    );
END;
GO

SELECT
    name AS external_data_source_name,
    location,
    type_desc
FROM sys.external_data_sources
WHERE name = N'ds_adls_synapse_serving';
GO
