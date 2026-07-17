/*
Project: azure-synapse-serverless-serving-layer
Script: 07_data_quality_queries.sql
Purpose: Validate external table data quality from the Synapse Serverless SQL serving layer.
Database: synapse_serving_demo

This script does not enforce constraints.
It proves that the serving layer can detect common data quality conditions through SQL.
*/

USE synapse_serving_demo;
GO

/* Row count validation */
SELECT 'customers' AS dataset_name, COUNT(*) AS row_count FROM ext.customers
UNION ALL
SELECT 'products' AS dataset_name, COUNT(*) AS row_count FROM ext.products
UNION ALL
SELECT 'orders' AS dataset_name, COUNT(*) AS row_count FROM ext.orders
UNION ALL
SELECT 'order_items' AS dataset_name, COUNT(*) AS row_count FROM ext.order_items
ORDER BY dataset_name;
GO

/* Data quality check summary */
WITH dq_checks AS (
    SELECT
        'duplicate_customer_ids' AS check_name,
        COUNT(*) AS issue_count
    FROM (
        SELECT customer_id
        FROM ext.customers
        GROUP BY customer_id
        HAVING COUNT(*) > 1
    ) AS x

    UNION ALL

    SELECT
        'duplicate_product_ids' AS check_name,
        COUNT(*) AS issue_count
    FROM (
        SELECT product_id
        FROM ext.products
        GROUP BY product_id
        HAVING COUNT(*) > 1
    ) AS x

    UNION ALL

    SELECT
        'duplicate_order_ids' AS check_name,
        COUNT(*) AS issue_count
    FROM (
        SELECT order_id
        FROM ext.orders
        GROUP BY order_id
        HAVING COUNT(*) > 1
    ) AS x

    UNION ALL

    SELECT
        'duplicate_order_item_ids' AS check_name,
        COUNT(*) AS issue_count
    FROM (
        SELECT order_item_id
        FROM ext.order_items
        GROUP BY order_item_id
        HAVING COUNT(*) > 1
    ) AS x

    UNION ALL

    SELECT
        'orders_without_customer' AS check_name,
        COUNT(*) AS issue_count
    FROM ext.orders AS o
    LEFT JOIN ext.customers AS c
        ON o.customer_id = c.customer_id
    WHERE c.customer_id IS NULL

    UNION ALL

    SELECT
        'order_items_without_order' AS check_name,
        COUNT(*) AS issue_count
    FROM ext.order_items AS oi
    LEFT JOIN ext.orders AS o
        ON oi.order_id = o.order_id
    WHERE o.order_id IS NULL

    UNION ALL

    SELECT
        'order_items_without_product' AS check_name,
        COUNT(*) AS issue_count
    FROM ext.order_items AS oi
    LEFT JOIN ext.products AS p
        ON oi.product_id = p.product_id
    WHERE p.product_id IS NULL

    UNION ALL

    SELECT
        'negative_order_totals' AS check_name,
        COUNT(*) AS issue_count
    FROM ext.orders
    WHERE order_total < 0

    UNION ALL

    SELECT
        'negative_line_totals' AS check_name,
        COUNT(*) AS issue_count
    FROM ext.order_items
    WHERE line_total < 0

    UNION ALL

    SELECT
        'invalid_order_statuses' AS check_name,
        COUNT(*) AS issue_count
    FROM ext.orders
    WHERE order_status NOT IN ('COMPLETED', 'PAID', 'PENDING', 'CANCELLED', 'REFUNDED')

    UNION ALL

    SELECT
        'invalid_payment_statuses' AS check_name,
        COUNT(*) AS issue_count
    FROM ext.orders
    WHERE payment_status NOT IN ('APPROVED', 'PENDING', 'DECLINED', 'REFUNDED')

    UNION ALL

    SELECT
        'line_total_mismatches' AS check_name,
        COUNT(*) AS issue_count
    FROM ext.order_items
    WHERE ABS(CAST(line_total AS decimal(18,2)) - CAST(quantity * unit_price AS decimal(18,2))) > 0.01

    UNION ALL

    SELECT
        'order_total_mismatches' AS check_name,
        COUNT(*) AS issue_count
    FROM ext.orders AS o
    INNER JOIN (
        SELECT
            order_id,
            CAST(SUM(line_total) AS decimal(18,2)) AS calculated_order_total
        FROM ext.order_items
        GROUP BY order_id
    ) AS oi
        ON o.order_id = oi.order_id
    WHERE ABS(CAST(o.order_total AS decimal(18,2)) - oi.calculated_order_total) > 0.01
)
SELECT
    check_name,
    issue_count,
    CASE WHEN issue_count = 0 THEN 'PASS' ELSE 'FAIL' END AS check_status
FROM dq_checks
ORDER BY check_name;
GO

/* Final data quality status */
WITH dq_checks AS (
    SELECT COUNT(*) AS issue_count
    FROM (
        SELECT customer_id FROM ext.customers GROUP BY customer_id HAVING COUNT(*) > 1
    ) AS x

    UNION ALL SELECT COUNT(*) FROM (
        SELECT product_id FROM ext.products GROUP BY product_id HAVING COUNT(*) > 1
    ) AS x

    UNION ALL SELECT COUNT(*) FROM (
        SELECT order_id FROM ext.orders GROUP BY order_id HAVING COUNT(*) > 1
    ) AS x

    UNION ALL SELECT COUNT(*) FROM (
        SELECT order_item_id FROM ext.order_items GROUP BY order_item_id HAVING COUNT(*) > 1
    ) AS x

    UNION ALL SELECT COUNT(*)
    FROM ext.orders AS o
    LEFT JOIN ext.customers AS c ON o.customer_id = c.customer_id
    WHERE c.customer_id IS NULL

    UNION ALL SELECT COUNT(*)
    FROM ext.order_items AS oi
    LEFT JOIN ext.orders AS o ON oi.order_id = o.order_id
    WHERE o.order_id IS NULL

    UNION ALL SELECT COUNT(*)
    FROM ext.order_items AS oi
    LEFT JOIN ext.products AS p ON oi.product_id = p.product_id
    WHERE p.product_id IS NULL

    UNION ALL SELECT COUNT(*) FROM ext.orders WHERE order_total < 0
    UNION ALL SELECT COUNT(*) FROM ext.order_items WHERE line_total < 0
    UNION ALL SELECT COUNT(*) FROM ext.orders WHERE order_status NOT IN ('COMPLETED', 'PAID', 'PENDING', 'CANCELLED', 'REFUNDED')
    UNION ALL SELECT COUNT(*) FROM ext.orders WHERE payment_status NOT IN ('APPROVED', 'PENDING', 'DECLINED', 'REFUNDED')
    UNION ALL SELECT COUNT(*) FROM ext.order_items WHERE ABS(CAST(line_total AS decimal(18,2)) - CAST(quantity * unit_price AS decimal(18,2))) > 0.01
    UNION ALL SELECT COUNT(*)
    FROM ext.orders AS o
    INNER JOIN (
        SELECT order_id, CAST(SUM(line_total) AS decimal(18,2)) AS calculated_order_total
        FROM ext.order_items
        GROUP BY order_id
    ) AS oi ON o.order_id = oi.order_id
    WHERE ABS(CAST(o.order_total AS decimal(18,2)) - oi.calculated_order_total) > 0.01
)
SELECT
    COUNT(*) AS total_quality_checks,
    SUM(CASE WHEN issue_count = 0 THEN 1 ELSE 0 END) AS passed_quality_checks,
    SUM(CASE WHEN issue_count > 0 THEN 1 ELSE 0 END) AS failed_quality_checks,
    SUM(issue_count) AS total_issue_count,
    CASE WHEN SUM(issue_count) = 0 THEN 'PASS' ELSE 'FAIL' END AS data_quality_status
FROM dq_checks;
GO
