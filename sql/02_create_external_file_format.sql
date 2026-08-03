/*
Project: azure-synapse-serverless-serving-layer
Script: 02_create_external_file_format.sql
Purpose: Create schemas and Parquet external file format for Synapse Serverless SQL.

Execution context:
- Run in Azure Synapse Studio.
- Connect to: Built-in serverless SQL pool.
- Database: synapse_serving_demo.

Prerequisite:
- sql/01_create_external_data_source.sql already created ds_adls_synapse_serving.
*/

USE synapse_serving_demo;
GO

/*
Create project schemas.
Synapse SQL does not support CREATE SCHEMA IF NOT EXISTS directly,
so we check sys.schemas first and run dynamic SQL only when needed.
*/
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'ext')
BEGIN
    EXEC(N'CREATE SCHEMA ext;');
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'rpt')
BEGIN
    EXEC(N'CREATE SCHEMA rpt;');
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'audit')
BEGIN
    EXEC(N'CREATE SCHEMA audit;');
END;
GO

/*
Create a Parquet external file format.
This format will be reused by all external tables that read curated Parquet files.
*/
IF NOT EXISTS (
    SELECT 1
    FROM sys.external_file_formats
    WHERE name = N'ff_parquet'
)
BEGIN
    CREATE EXTERNAL FILE FORMAT ff_parquet
    WITH (
        FORMAT_TYPE = PARQUET
    );
END;
GO

/*
Validation: confirm schemas exist.
*/
SELECT
    name AS schema_name
FROM sys.schemas
WHERE name IN (N'ext', N'rpt', N'audit')
ORDER BY name;
GO

/*
Validation: confirm external file format exists.
*/
SELECT
    name AS external_file_format_name,
    format_type
FROM sys.external_file_formats
WHERE name = N'ff_parquet';
GO

/*
Smoke test: read one Parquet file directly from ADLS through the external data source.
This validates that Synapse can reach the uploaded curated files.
*/
SELECT TOP 10
    *
FROM OPENROWSET(
    BULK 'curated/retail/customers/customers.parquet',
    DATA_SOURCE = 'ds_adls_synapse_serving',
    FORMAT = 'PARQUET'
) AS customers;
GO
