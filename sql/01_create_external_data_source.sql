/*
Project: azure-synapse-serverless-serving-layer
Script: 01_create_external_data_source.sql
Purpose: Create the database scoped credential and external data source for ADLS Gen2.

Known project values:
- Storage account: synapselabdan
- Container: synapse-serving
- External data source: ds_adls_synapse_serving
- Credential: cred_synapse_workspace_mi

Before running:
1. Confirm database [synapse_serving_demo] already exists.
2. Replace <local-master-key-password-do-not-commit> with a strong local password before execution.
3. Do NOT commit the real password to GitHub.
4. Grant the Synapse workspace managed identity at least Storage Blob Data Reader access to the container.
   For CETAS/write scenarios later, Storage Blob Data Contributor may be required.

Important:
The MASTER KEY password is NOT the storage account key.
It is a database-level password used by SQL to protect database-scoped credentials.
This project uses Managed Identity, so no storage key, SAS token, or connection string belongs in this script.
*/

USE [synapse_serving_demo];
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.symmetric_keys
    WHERE name = N'##MS_DatabaseMasterKey##'
)
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'o|40BBjv7hb@';
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
        LOCATION = 'abfss://synapse-serving@synapselabdan.dfs.core.windows.net',
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
