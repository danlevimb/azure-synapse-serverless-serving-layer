/*
    Project: azure-synapse-serverless-serving-layer
    Script: 08_cetas_output.sql
    Purpose: Create a curated analytical output in ADLS Gen2 using CETAS.

    Run this script in database: synapse_serving_demo
    Connection: Built-in / Serverless SQL

    Notes:
    - CETAS creates an external table and writes query output files to ADLS.
    - The output LOCATION must not already contain files.
    - If you need to rerun this script, either:
        1) Delete the ADLS folder:
           serving/retail/sales_by_date_cetas/run_id=manual_001/
        2) Or change the LOCATION to a new run_id value, for example:
           serving/retail/sales_by_date_cetas/run_id=manual_002/

    Schema note:
    - rpt.vw_sales_by_date exposes total_revenue.
    - It does not expose gross_revenue or completed_revenue.
*/

USE synapse_serving_demo;
GO

/*
    Drop only the external table metadata if it already exists.
    This does NOT delete files from ADLS.
*/
IF EXISTS (
    SELECT 1
    FROM sys.external_tables et
    INNER JOIN sys.schemas s
        ON et.schema_id = s.schema_id
    WHERE s.name = 'rpt'
      AND et.name = 'sales_by_date_cetas'
)
BEGIN
    DROP EXTERNAL TABLE rpt.sales_by_date_cetas;
END;
GO

/*
    Create a materialized serving output from the reporting view.
    The files will be written under:

    abfss://synapse-serving@synapselabdan.dfs.core.windows.net/serving/retail/sales_by_date_cetas/run_id=manual_001/
*/
CREATE EXTERNAL TABLE rpt.sales_by_date_cetas
WITH
(
    LOCATION = 'serving/retail/sales_by_date_cetas/run_id=manual_001/',
    DATA_SOURCE = ds_adls_synapse_serving,
    FILE_FORMAT = ff_parquet
)
AS
SELECT
    order_date,
    order_count,
    total_quantity,
    total_revenue
FROM rpt.vw_sales_by_date;
GO

/*
    Confirm that the external table metadata exists.
*/
SELECT
    s.name AS schema_name,
    et.name AS external_table_name,
    ds.name AS external_data_source_name,
    ds.location AS external_data_source_location,
    ff.name AS external_file_format_name,
    et.location AS table_location
FROM sys.external_tables et
INNER JOIN sys.schemas s
    ON et.schema_id = s.schema_id
INNER JOIN sys.external_data_sources ds
    ON et.data_source_id = ds.data_source_id
INNER JOIN sys.external_file_formats ff
    ON et.file_format_id = ff.file_format_id
WHERE s.name = 'rpt'
  AND et.name = 'sales_by_date_cetas';
GO

/*
    Preview the CETAS external table.
*/
SELECT TOP (20)
    order_date,
    order_count,
    total_quantity,
    total_revenue
FROM rpt.sales_by_date_cetas
ORDER BY order_date;
GO
