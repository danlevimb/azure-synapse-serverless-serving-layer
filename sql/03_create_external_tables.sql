/*
Project: azure-synapse-serverless-serving-layer
Script: 03_create_external_tables.sql
Purpose: Create Synapse Serverless SQL external tables over curated retail Parquet files in ADLS Gen2.

Execution context:
- Run in Azure Synapse Studio.
- Connect to: Built-in serverless SQL pool.
- Database: synapse_serving_demo.

Prerequisites:
- sql/01_create_external_data_source.sql created ds_adls_synapse_serving.
- sql/02_create_external_file_format.sql created ff_parquet and schemas ext/rpt/audit.
*/

USE synapse_serving_demo;
GO

/*
Drop external tables if they already exist.
This makes the script safe to rerun during lab development.
*/
IF EXISTS (
    SELECT 1
    FROM sys.external_tables
    WHERE name = N'order_items'
      AND schema_id = SCHEMA_ID(N'ext')
)
BEGIN
    DROP EXTERNAL TABLE ext.order_items;
END;
GO

IF EXISTS (
    SELECT 1
    FROM sys.external_tables
    WHERE name = N'orders'
      AND schema_id = SCHEMA_ID(N'ext')
)
BEGIN
    DROP EXTERNAL TABLE ext.orders;
END;
GO

IF EXISTS (
    SELECT 1
    FROM sys.external_tables
    WHERE name = N'products'
      AND schema_id = SCHEMA_ID(N'ext')
)
BEGIN
    DROP EXTERNAL TABLE ext.products;
END;
GO

IF EXISTS (
    SELECT 1
    FROM sys.external_tables
    WHERE name = N'customers'
      AND schema_id = SCHEMA_ID(N'ext')
)
BEGIN
    DROP EXTERNAL TABLE ext.customers;
END;
GO

/*
External table: customers
Location maps to:
abfss://synapse-serving@synapselabdan.dfs.core.windows.net/curated/retail/customers/
*/
CREATE EXTERNAL TABLE ext.customers
(
    customer_id       INT,
    customer_name     VARCHAR(100),
    email             VARCHAR(200),
    city              VARCHAR(100),
    state_code        VARCHAR(10),
    customer_segment  VARCHAR(50),
    created_at        DATETIME2(3),
    updated_at        DATETIME2(3)
)
WITH
(
    LOCATION = 'curated/retail/customers/',
    DATA_SOURCE = ds_adls_synapse_serving,
    FILE_FORMAT = ff_parquet
);
GO

/*
External table: products
*/
CREATE EXTERNAL TABLE ext.products
(
    product_id    INT,
    product_name  VARCHAR(150),
    category      VARCHAR(80),
    unit_price    DECIMAL(12, 2),
    is_active     BIT,
    created_at    DATETIME2(3),
    updated_at    DATETIME2(3)
)
WITH
(
    LOCATION = 'curated/retail/products/',
    DATA_SOURCE = ds_adls_synapse_serving,
    FILE_FORMAT = ff_parquet
);
GO

/*
External table: orders
*/
CREATE EXTERNAL TABLE ext.orders
(
    order_id        INT,
    customer_id     INT,
    order_date      DATE,
    order_status    VARCHAR(30),
    payment_status  VARCHAR(30),
    order_total     DECIMAL(12, 2),
    created_at      DATETIME2(3),
    updated_at      DATETIME2(3)
)
WITH
(
    LOCATION = 'curated/retail/orders/',
    DATA_SOURCE = ds_adls_synapse_serving,
    FILE_FORMAT = ff_parquet
);
GO

/*
External table: order_items
*/
CREATE EXTERNAL TABLE ext.order_items
(
    order_item_id  INT,
    order_id       INT,
    product_id     INT,
    quantity       INT,
    unit_price     DECIMAL(12, 2),
    line_total     DECIMAL(12, 2),
    created_at     DATETIME2(3),
    updated_at     DATETIME2(3)
)
WITH
(
    LOCATION = 'curated/retail/order_items/',
    DATA_SOURCE = ds_adls_synapse_serving,
    FILE_FORMAT = ff_parquet
);
GO

/*
Validation: confirm external tables exist.
*/
SELECT
    SCHEMA_NAME(schema_id) AS schema_name,
    name AS external_table_name
FROM sys.external_tables
WHERE SCHEMA_NAME(schema_id) = N'ext'
ORDER BY name;
GO

/*
Validation: row counts.
Expected counts depend on the generated sample data.
*/
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM ext.customers
UNION ALL
SELECT 'products' AS table_name, COUNT(*) AS row_count FROM ext.products
UNION ALL
SELECT 'orders' AS table_name, COUNT(*) AS row_count FROM ext.orders
UNION ALL
SELECT 'order_items' AS table_name, COUNT(*) AS row_count FROM ext.order_items;
GO

/*
Validation: preview data.
*/
SELECT TOP 10 * FROM ext.customers ORDER BY customer_id;
GO

SELECT TOP 10 * FROM ext.products ORDER BY product_id;
GO

SELECT TOP 10 * FROM ext.orders ORDER BY order_id;
GO

SELECT TOP 10 * FROM ext.order_items ORDER BY order_item_id;
GO
