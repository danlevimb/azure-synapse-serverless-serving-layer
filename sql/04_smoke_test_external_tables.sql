/*
Project: azure-synapse-serverless-serving-layer
Script: 04_smoke_test_external_tables.sql
Purpose: Validate that Synapse Serverless SQL can read all external tables.
*/

USE [synapse_serving_demo];
GO

SELECT 'customers' AS dataset_name, COUNT_BIG(*) AS row_count FROM [ext].[customers]
UNION ALL
SELECT 'products' AS dataset_name, COUNT_BIG(*) AS row_count FROM [ext].[products]
UNION ALL
SELECT 'orders' AS dataset_name, COUNT_BIG(*) AS row_count FROM [ext].[orders]
UNION ALL
SELECT 'order_items' AS dataset_name, COUNT_BIG(*) AS row_count FROM [ext].[order_items]
ORDER BY dataset_name;
GO

SELECT TOP (10)
    customer_id,
    customer_name,
    city,
    state_code,
    customer_segment
FROM [ext].[customers]
ORDER BY customer_id;
GO

SELECT TOP (10)
    order_id,
    customer_id,
    order_date,
    order_status,
    payment_status,
    order_total
FROM [ext].[orders]
ORDER BY order_id;
GO

SELECT
    CASE
        WHEN
            (SELECT COUNT_BIG(*) FROM [ext].[customers]) = 10
            AND (SELECT COUNT_BIG(*) FROM [ext].[products]) = 10
            AND (SELECT COUNT_BIG(*) FROM [ext].[orders]) = 24
            AND (SELECT COUNT_BIG(*) FROM [ext].[order_items]) = 43
        THEN 'PASS'
        ELSE 'REVIEW'
    END AS smoke_test_status;
GO
