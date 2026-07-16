/*
Project: azure-synapse-serverless-serving-layer
Script: 03_create_external_tables.sql
Purpose: Create external tables over curated Parquet datasets in ADLS Gen2.

Expected ADLS layout:

synapse-serving/
  curated/
    retail/
      customers/customers.parquet
      products/products.parquet
      orders/orders.parquet
      order_items/order_items.parquet
*/

USE [synapse_serving_demo];
GO

IF OBJECT_ID(N'ext.customers', N'U') IS NOT NULL
    DROP EXTERNAL TABLE [ext].[customers];
GO

CREATE EXTERNAL TABLE [ext].[customers]
(
    [customer_id]       int              NOT NULL,
    [customer_name]     varchar(100)     COLLATE Latin1_General_100_BIN2_UTF8 NOT NULL,
    [email]             varchar(200)     COLLATE Latin1_General_100_BIN2_UTF8 NULL,
    [city]              varchar(100)     COLLATE Latin1_General_100_BIN2_UTF8 NOT NULL,
    [state_code]        varchar(10)      COLLATE Latin1_General_100_BIN2_UTF8 NOT NULL,
    [customer_segment]  varchar(50)      COLLATE Latin1_General_100_BIN2_UTF8 NOT NULL,
    [created_at]        datetime2(3)     NOT NULL,
    [updated_at]        datetime2(3)     NOT NULL
)
WITH
(
    LOCATION = 'curated/retail/customers/',
    DATA_SOURCE = [ds_adls_synapse_serving],
    FILE_FORMAT = [ff_parquet]
);
GO

IF OBJECT_ID(N'ext.products', N'U') IS NOT NULL
    DROP EXTERNAL TABLE [ext].[products];
GO

CREATE EXTERNAL TABLE [ext].[products]
(
    [product_id]    int              NOT NULL,
    [product_name]  varchar(150)     COLLATE Latin1_General_100_BIN2_UTF8 NOT NULL,
    [category]      varchar(80)      COLLATE Latin1_General_100_BIN2_UTF8 NOT NULL,
    [unit_price]    decimal(12, 2)   NOT NULL,
    [is_active]     bit              NOT NULL,
    [created_at]    datetime2(3)     NOT NULL,
    [updated_at]    datetime2(3)     NOT NULL
)
WITH
(
    LOCATION = 'curated/retail/products/',
    DATA_SOURCE = [ds_adls_synapse_serving],
    FILE_FORMAT = [ff_parquet]
);
GO

IF OBJECT_ID(N'ext.orders', N'U') IS NOT NULL
    DROP EXTERNAL TABLE [ext].[orders];
GO

CREATE EXTERNAL TABLE [ext].[orders]
(
    [order_id]        int              NOT NULL,
    [customer_id]     int              NOT NULL,
    [order_date]      date             NOT NULL,
    [order_status]    varchar(30)      COLLATE Latin1_General_100_BIN2_UTF8 NOT NULL,
    [payment_status]  varchar(30)      COLLATE Latin1_General_100_BIN2_UTF8 NOT NULL,
    [order_total]     decimal(12, 2)   NOT NULL,
    [created_at]      datetime2(3)     NOT NULL,
    [updated_at]      datetime2(3)     NOT NULL
)
WITH
(
    LOCATION = 'curated/retail/orders/',
    DATA_SOURCE = [ds_adls_synapse_serving],
    FILE_FORMAT = [ff_parquet]
);
GO

IF OBJECT_ID(N'ext.order_items', N'U') IS NOT NULL
    DROP EXTERNAL TABLE [ext].[order_items];
GO

CREATE EXTERNAL TABLE [ext].[order_items]
(
    [order_item_id]  int              NOT NULL,
    [order_id]       int              NOT NULL,
    [product_id]     int              NOT NULL,
    [quantity]       int              NOT NULL,
    [unit_price]     decimal(12, 2)   NOT NULL,
    [line_total]     decimal(12, 2)   NOT NULL,
    [created_at]     datetime2(3)     NOT NULL,
    [updated_at]     datetime2(3)     NOT NULL
)
WITH
(
    LOCATION = 'curated/retail/order_items/',
    DATA_SOURCE = [ds_adls_synapse_serving],
    FILE_FORMAT = [ff_parquet]
);
GO

SELECT
    s.name AS schema_name,
    t.name AS external_table_name,
    ds.name AS external_data_source_name,
    ds.location AS external_data_source_location,
    ff.name AS external_file_format_name,
    t.location AS table_location
FROM sys.external_tables AS t
INNER JOIN sys.schemas AS s
    ON t.schema_id = s.schema_id
INNER JOIN sys.external_data_sources AS ds
    ON t.data_source_id = ds.data_source_id
INNER JOIN sys.external_file_formats AS ff
    ON t.file_format_id = ff.file_format_id
WHERE s.name = N'ext'
ORDER BY t.name;
GO
