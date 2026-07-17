/*
    Project: azure-synapse-serverless-serving-layer
    Script: 09_validate_cetas_output.sql
    Purpose: Validate the CETAS output created by 08_cetas_output.sql.

    Run this script in database: synapse_serving_demo
    Connection: Built-in / Serverless SQL

    Important Synapse Serverless note:
    Do not combine sys catalog views with queries over external data in the same
    distributed query/CTE. Serverless SQL can raise:

        The query references an object that is not supported in distributed processing mode.

    This script keeps metadata validation and external-data validation in separate
    result sets.

    Schema note:
    - rpt.vw_sales_by_date exposes total_revenue.
    - rpt.sales_by_date_cetas should expose total_revenue.
    - completed_revenue is not part of this CETAS output.
*/

USE synapse_serving_demo;
GO

/*
    1) Metadata validation only.
    This checks that the CETAS external table metadata exists.
    It does not query external data.
*/
SELECT
    CASE
        WHEN EXISTS
        (
            SELECT 1
            FROM sys.external_tables et
            INNER JOIN sys.schemas s
                ON et.schema_id = s.schema_id
            WHERE s.name = 'rpt'
              AND et.name = 'sales_by_date_cetas'
        )
        THEN 1
        ELSE 0
    END AS cetas_external_table_exists,
    CASE
        WHEN EXISTS
        (
            SELECT 1
            FROM sys.external_tables et
            INNER JOIN sys.schemas s
                ON et.schema_id = s.schema_id
            WHERE s.name = 'rpt'
              AND et.name = 'sales_by_date_cetas'
        )
        THEN 'PASS'
        ELSE 'FAIL'
    END AS cetas_metadata_status;
GO

/*
    2) External-data validation only.
    This compares row counts and business aggregates between the source view
    and the materialized CETAS external table.
*/
WITH source_agg AS
(
    SELECT
        COUNT(*) AS source_view_row_count,
        SUM(order_count) AS source_order_count,
        SUM(total_quantity) AS source_total_quantity,
        CAST(SUM(total_revenue) AS decimal(18,2)) AS source_total_revenue
    FROM rpt.vw_sales_by_date
),
output_agg AS
(
    SELECT
        COUNT(*) AS cetas_output_row_count,
        SUM(order_count) AS cetas_order_count,
        SUM(total_quantity) AS cetas_total_quantity,
        CAST(SUM(total_revenue) AS decimal(18,2)) AS cetas_total_revenue
    FROM rpt.sales_by_date_cetas
)
SELECT
    source_view_row_count,
    cetas_output_row_count,
    source_order_count,
    cetas_order_count,
    source_total_quantity,
    cetas_total_quantity,
    source_total_revenue,
    cetas_total_revenue,
    CASE
        WHEN source_view_row_count = cetas_output_row_count
         AND source_order_count = cetas_order_count
         AND source_total_quantity = cetas_total_quantity
         AND source_total_revenue = cetas_total_revenue
        THEN 'PASS'
        ELSE 'FAIL'
    END AS cetas_output_validation_status
FROM source_agg
CROSS JOIN output_agg;
GO

/*
    3) Business-level sanity validation of the materialized output.
*/
SELECT
    COUNT(*) AS output_row_count,
    SUM(order_count) AS total_orders_in_output,
    SUM(total_quantity) AS total_quantity_in_output,
    CAST(SUM(total_revenue) AS decimal(18,2)) AS total_revenue_in_output,
    CASE
        WHEN COUNT(*) > 0
         AND SUM(order_count) > 0
         AND SUM(total_quantity) > 0
         AND SUM(total_revenue) > 0
        THEN 'PASS'
        ELSE 'FAIL'
    END AS cetas_business_validation_status
FROM rpt.sales_by_date_cetas;
GO

/*
    4) Preview the materialized serving output.
*/
SELECT TOP (20)
    order_date,
    order_count,
    total_quantity,
    total_revenue
FROM rpt.sales_by_date_cetas
ORDER BY order_date;
GO
