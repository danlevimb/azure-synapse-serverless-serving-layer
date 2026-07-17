# Query Examples

**Project:** `azure-synapse-serverless-serving-layer`  
**Document:** Query Examples  
**Status:** Phase 6 — Documentation and Evidence Package  
**Last updated:** 2026-07-16

## 1. Purpose

This document describes the analytical SQL query patterns implemented in the `azure-synapse-serverless-serving-layer` project.

The purpose of these queries is to prove that curated Parquet files stored in Azure Data Lake Storage Gen2 can be exposed through Synapse Serverless SQL and consumed through familiar SQL reporting patterns.

## 2. Query Layer Strategy

The project separates the query layer into two levels:

| Layer | Object Type | Purpose |
|---|---|---|
| External tables | `ext.*` | Direct SQL access to curated Parquet files |
| Reporting views | `rpt.*` | Business-friendly analytical surfaces |

Consumers should normally query the `rpt` views instead of writing joins directly against the `ext` tables.

## 3. Base Revenue View

### View

```text
rpt.vw_revenue_order_lines
```

### Purpose

Provides a reusable joined dataset combining:

- Order headers
- Order items
- Products
- Customers

This view is the base for most revenue-related reporting.

### Business Value

Instead of requiring users to repeatedly join four external tables, the base view provides a clean analytical surface with revenue-relevant fields already aligned.

## 4. Sales by Date

### View

```text
rpt.vw_sales_by_date
```

### Question Answered

```text
What are total sales by date?
```

### Example Query

```sql
SELECT
    order_date,
    order_count,
    total_quantity,
    total_revenue
FROM rpt.vw_sales_by_date
ORDER BY order_date;
```

### Business Value

This query supports daily revenue tracking and can be used as a simple BI-ready time series output.

## 5. Sales by Customer

### View

```text
rpt.vw_sales_by_customer
```

### Question Answered

```text
Which customers generate the most revenue?
```

### Example Query

```sql
SELECT TOP 10
    customer_id,
    customer_name,
    city,
    state_code,
    order_count,
    total_quantity,
    total_revenue
FROM rpt.vw_sales_by_customer
ORDER BY total_revenue DESC;
```

### Business Value

This query identifies top customers and supports customer-level revenue analysis.

## 6. Sales by Product

### View

```text
rpt.vw_sales_by_product
```

### Question Answered

```text
Which products sell the most and generate the most revenue?
```

### Example Query

```sql
SELECT TOP 10
    product_id,
    product_name,
    category,
    total_quantity,
    total_revenue
FROM rpt.vw_sales_by_product
ORDER BY total_revenue DESC;
```

### Business Value

This query supports product ranking, category analysis, and sales performance review.

## 7. Sales by City

### View

```text
rpt.vw_sales_by_city
```

### Question Answered

```text
Which cities generate the highest revenue?
```

### Example Query

```sql
SELECT
    city,
    state_code,
    customer_count,
    order_count,
    total_revenue
FROM rpt.vw_sales_by_city
ORDER BY total_revenue DESC;
```

### Business Value

This query provides geography-level analysis and can support market or regional sales review.

## 8. Order Status Summary

### View

```text
rpt.vw_order_status_summary
```

### Question Answered

```text
What is the distribution of order and payment statuses?
```

### Example Query

```sql
SELECT
    order_status,
    payment_status,
    order_count,
    total_order_amount
FROM rpt.vw_order_status_summary
ORDER BY order_status, payment_status;
```

### Business Value

This query helps identify operational order states such as completed, pending, cancelled, or refunded orders.

## 9. Data Quality Query Patterns

The project also includes SQL validation checks to prove that the serving layer can detect common data quality issues.

Validation categories include:

- Duplicate business keys
- Orphan orders without customers
- Orphan order items without orders
- Orphan order items without products
- Negative order totals
- Negative line totals
- Invalid order statuses
- Invalid payment statuses
- Line total mismatches
- Order total mismatches

The expected final status is:

```text
Data quality status = PASS
```

## 10. CETAS Validation Query Pattern

The CETAS output is validated by comparing the materialized external table to the source reporting view.

Validation categories include:

- CETAS external table exists
- Source row count matches output row count
- Aggregated `order_count` matches
- Aggregated `total_quantity` matches
- Aggregated `total_revenue` matches
- Output contains positive revenue

Expected status:

```text
CETAS validation status = PASS
```

## 11. Cost-Aware Querying Notes

Because Synapse Serverless SQL charges by data processed, analytical queries should follow these principles:

- Select only required columns.
- Prefer reporting views with clear purpose.
- Avoid unnecessary exploratory `SELECT *` queries over large datasets.
- Use Parquet files for columnar scanning efficiency.
- Keep sample datasets small for portfolio execution.
- Use row count and validation queries intentionally.

## 12. Implemented Query Scripts

| Script | Purpose |
|---|---|
| `06_analytical_queries.sql` | Business analytical query examples |
| `07_data_quality_queries.sql` | Data quality validation checks |
| `09_validate_cetas_output.sql` | CETAS output validation |

## 13. Success Criteria

The query layer is successful when:

1. Reporting views are created successfully.
2. Analytical queries return meaningful business results.
3. Analytical validation returns `PASS`.
4. Data quality validation returns `PASS`.
5. CETAS validation returns `PASS`.
6. The queries are clear enough to explain in an interview.

## 14. Professional Value

These query examples demonstrate that the project is not only a storage or infrastructure exercise.

It delivers a practical SQL consumption layer that answers business questions over curated lake data using Synapse Serverless SQL.
