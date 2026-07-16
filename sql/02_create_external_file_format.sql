/*
Project: azure-synapse-serverless-serving-layer
Script: 02_create_external_file_format.sql
Purpose: Create the external file format for curated Parquet datasets.
*/

USE [synapse_serving_demo];
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.external_file_formats
    WHERE name = N'ff_parquet'
)
BEGIN
    CREATE EXTERNAL FILE FORMAT [ff_parquet]
    WITH (
        FORMAT_TYPE = PARQUET
    );
END;
GO

SELECT
    name AS external_file_format_name,
    format_type
FROM sys.external_file_formats
WHERE name = N'ff_parquet';
GO
