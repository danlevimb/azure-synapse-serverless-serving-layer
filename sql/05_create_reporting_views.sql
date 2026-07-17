/*
Project: azure-synapse-serverless-serving-layer
Script: 05_create_reporting_views.sql
Purpose: Create reporting views over external Parquet tables in Synapse Serverless SQL.
Database: synapse_serving_demo

Notes:
- Run this script after external tables are created and smoke tested.
- External tables are schema-on-read; business rules are expressed in views and validation queries.
*/

USE synapse_serving_demo;
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'rpt')
BEGIN
    EXEC('CREATE SCHEMA rpt');
END;
GO

/*
Base analytical view.
Only revenue-positive business events are included:
- Order status COMPLETED or PAID
- Payment status APPROVED

Cancelled, pending, declined, and refunded orders are intentionally excluded from revenue views.
*/
DROP VIEW IF EXISTS rpt.vw_revenue_order_lines;
GO

CREATE VIEW rpt.vw_revenue_order_lines AS
SELECT
    o.order_id,
    o.order_date,
    o.order_status,
    o.payment_status,
    c.customer_id,
    c.customer_name,
    c.city,
    c.state_code,
    c.customer_segment,
    p.product_id,
    p.product_name,
    p.category,
    oi.order_item_id,
    oi.quantity,
    oi.unit_price,
    oi.line_total
FROM ext.orders AS o
INNER JOIN ext.customers AS c
    ON o.customer_id = c.customer_id
INNER JOIN ext.order_items AS oi
    ON o.order_id = oi.order_id
INNER JOIN ext.products AS p
    ON oi.product_id = p.product_id
WHERE o.order_status IN ('COMPLETED', 'PAID')
  AND o.payment_status = 'APPROVED';
GO

DROP VIEW IF EXISTS rpt.vw_sales_by_date;
GO

CREATE VIEW rpt.vw_sales_by_date AS
SELECT
    order_date,
    COUNT(DISTINCT order_id) AS order_count,
    SUM(quantity) AS total_quantity,
    CAST(SUM(line_total) AS decimal(18,2)) AS total_revenue
FROM rpt.vw_revenue_order_lines
GROUP BY order_date;
GO

DROP VIEW IF EXISTS rpt.vw_sales_by_customer;
GO

CREATE VIEW rpt.vw_sales_by_customer AS
SELECT
    customer_id,
    customer_name,
    city,
    state_code,
    customer_segment,
    COUNT(DISTINCT order_id) AS order_count,
    SUM(quantity) AS total_quantity,
    CAST(SUM(line_total) AS decimal(18,2)) AS total_revenue,
    MAX(order_date) AS last_order_date
FROM rpt.vw_revenue_order_lines
GROUP BY
    customer_id,
    customer_name,
    city,
    state_code,
    customer_segment;
GO

DROP VIEW IF EXISTS rpt.vw_sales_by_product;
GO

CREATE VIEW rpt.vw_sales_by_product AS
SELECT
    product_id,
    product_name,
    category,
    COUNT(DISTINCT order_id) AS order_count,
    SUM(quantity) AS total_quantity,
    CAST(SUM(line_total) AS decimal(18,2)) AS total_revenue
FROM rpt.vw_revenue_order_lines
GROUP BY
    product_id,
    product_name,
    category;
GO

DROP VIEW IF EXISTS rpt.vw_sales_by_city;
GO

CREATE VIEW rpt.vw_sales_by_city AS
SELECT
    city,
    state_code,
    COUNT(DISTINCT customer_id) AS customer_count,
    COUNT(DISTINCT order_id) AS order_count,
    SUM(quantity) AS total_quantity,
    CAST(SUM(line_total) AS decimal(18,2)) AS total_revenue
FROM rpt.vw_revenue_order_lines
GROUP BY
    city,
    state_code;
GO

DROP VIEW IF EXISTS rpt.vw_order_status_summary;
GO

CREATE VIEW rpt.vw_order_status_summary AS
SELECT
    order_status,
    payment_status,
    COUNT(*) AS order_count,
    CAST(SUM(order_total) AS decimal(18,2)) AS total_order_amount
FROM ext.orders
GROUP BY
    order_status,
    payment_status;
GO

/* Verification resultset */
SELECT
    s.name AS schema_name,
    v.name AS view_name
FROM sys.views AS v
INNER JOIN sys.schemas AS s
    ON v.schema_id = s.schema_id
WHERE s.name = 'rpt'
ORDER BY v.name;
GO
