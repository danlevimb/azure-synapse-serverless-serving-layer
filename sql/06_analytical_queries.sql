/*
Project: azure-synapse-serverless-serving-layer
Script: 06_analytical_queries.sql
Purpose: Run analytical query examples over Synapse Serverless SQL reporting views.
Database: synapse_serving_demo
*/

USE synapse_serving_demo;
GO

/* Query 1: Sales by date */
SELECT
    order_date,
    order_count,
    total_quantity,
    total_revenue
FROM rpt.vw_sales_by_date
ORDER BY order_date;
GO

/* Query 2: Top customers by revenue */
SELECT TOP 10
    customer_id,
    customer_name,
    city,
    state_code,
    customer_segment,
    order_count,
    total_quantity,
    total_revenue,
    last_order_date
FROM rpt.vw_sales_by_customer
ORDER BY total_revenue DESC;
GO

/* Query 3: Product sales ranking */
SELECT TOP 10
    product_id,
    product_name,
    category,
    order_count,
    total_quantity,
    total_revenue
FROM rpt.vw_sales_by_product
ORDER BY total_revenue DESC;
GO

/* Query 4: Revenue by city */
SELECT
    city,
    state_code,
    customer_count,
    order_count,
    total_quantity,
    total_revenue
FROM rpt.vw_sales_by_city
ORDER BY total_revenue DESC;
GO

/* Query 5: Order and payment status distribution */
SELECT
    order_status,
    payment_status,
    order_count,
    total_order_amount
FROM rpt.vw_order_status_summary
ORDER BY order_status, payment_status;
GO

/* Query 6: Portfolio validation summary for reporting views */
WITH validation_checks AS (
    SELECT
        'sales_by_date_has_rows' AS check_name,
        CASE WHEN EXISTS (SELECT 1 FROM rpt.vw_sales_by_date) THEN 1 ELSE 0 END AS passed
    UNION ALL
    SELECT
        'sales_by_customer_has_rows' AS check_name,
        CASE WHEN EXISTS (SELECT 1 FROM rpt.vw_sales_by_customer) THEN 1 ELSE 0 END AS passed
    UNION ALL
    SELECT
        'sales_by_product_has_rows' AS check_name,
        CASE WHEN EXISTS (SELECT 1 FROM rpt.vw_sales_by_product) THEN 1 ELSE 0 END AS passed
    UNION ALL
    SELECT
        'sales_by_city_has_rows' AS check_name,
        CASE WHEN EXISTS (SELECT 1 FROM rpt.vw_sales_by_city) THEN 1 ELSE 0 END AS passed
    UNION ALL
    SELECT
        'order_status_summary_has_rows' AS check_name,
        CASE WHEN EXISTS (SELECT 1 FROM rpt.vw_order_status_summary) THEN 1 ELSE 0 END AS passed
)
SELECT
    COUNT(*) AS total_checks,
    SUM(passed) AS passed_checks,
    COUNT(*) - SUM(passed) AS failed_checks,
    CASE WHEN COUNT(*) = SUM(passed) THEN 'PASS' ELSE 'FAIL' END AS analytical_views_status
FROM validation_checks;
GO
