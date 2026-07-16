/*
Project: azure-synapse-serverless-serving-layer
Script: 00_create_database.sql
Purpose: Create the serverless SQL database and logical schemas used by the project.

Run this script from the Azure Synapse Serverless SQL endpoint.
Recommended connection database for the first execution: master.

Note:
- The database uses a UTF-8 collation because Parquet string values are encoded as UTF-8.
- If the database already exists with a different collation, review before changing it.
*/

IF NOT EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = N'synapse_serving_demo'
)
BEGIN
    CREATE DATABASE [synapse_serving_demo]
    COLLATE Latin1_General_100_BIN2_UTF8;
END;
GO

USE [synapse_serving_demo];
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = N'ext'
)
BEGIN
    EXEC('CREATE SCHEMA [ext] AUTHORIZATION [dbo];');
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = N'rpt'
)
BEGIN
    EXEC('CREATE SCHEMA [rpt] AUTHORIZATION [dbo];');
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = N'audit'
)
BEGIN
    EXEC('CREATE SCHEMA [audit] AUTHORIZATION [dbo];');
END;
GO

SELECT
    DB_NAME() AS current_database,
    CONVERT(varchar(128), DATABASEPROPERTYEX(DB_NAME(), 'Collation')) AS database_collation,
    'PASS' AS setup_status;
GO
