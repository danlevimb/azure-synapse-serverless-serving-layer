# Source Data Model

**Project:** `azure-synapse-serverless-serving-layer`  
**Document:** Source Data Model  
**Status:** Phase 1 — Repository Foundation  
**Last updated:** 2026-07-13

## 1. Purpose

This document defines the controlled retail data model used by the `azure-synapse-serverless-serving-layer` project.

The goal of the dataset is to support a SQL serving layer over curated Parquet files stored in Azure Data Lake Storage Gen2 and queried through Azure Synapse Serverless SQL.

This project does not focus on raw ingestion or complex transformation.

The focus is:

```text
Curated Parquet files → External Tables → Reporting Views → Analytical SQL Queries
```

## 2. Business Scenario

A retail business wants to expose curated sales data to analytical users through SQL.

The curated data lake contains customer, product, order, and order item datasets.

Analytical users need to answer questions such as:

- What are total sales by date?
- Which customers generate the most revenue?
- Which products sell the most?
- Which cities generate the highest revenue?
- What is the distribution of order statuses?
- Are there basic data quality issues visible from the serving layer?

## 3. Dataset Design Principle

The dataset should be small, synthetic, controlled, and easy to validate.

It should be large enough to support useful analytical queries, but small enough to keep Azure cost and project complexity low.

Recommended minimum dataset size:

| Dataset | Recommended Row Count |
|---|---:|
| `customers` | 8–12 rows |
| `products` | 8–12 rows |
| `orders` | 15–25 rows |
| `order_items` | 30–60 rows |

The dataset is intentionally simple because the project objective is the serving layer, not data generation complexity.

## 4. Logical Data Model

The MVP uses four curated datasets:

```text
customers
products
orders
order_items
```

Logical relationships:

```text
customers.customer_id  → orders.customer_id
orders.order_id       → order_items.order_id
products.product_id   → order_items.product_id
```

Relationship summary:

| Relationship | Type | Description |
|---|---|---|
| `customers` → `orders` | One-to-many | One customer can place many orders |
| `orders` → `order_items` | One-to-many | One order can contain many line items |
| `products` → `order_items` | One-to-many | One product can appear in many order lines |

## 5. Dataset Grain

| Dataset | Grain |
|---|---|
| `customers` | One row per customer |
| `products` | One row per product |
| `orders` | One row per order header |
| `order_items` | One row per product line inside an order |

The distinction between `orders` and `order_items` is important.

`orders` stores the order header.

`order_items` stores the line-level detail required to analyze product-level sales.

## 6. Dataset: `customers`

### Purpose

Stores customer attributes used for customer-level and geography-level reporting.

### Expected ADLS Path

```text
curated/retail/customers/
```

### Proposed Schema

| Column | Type | Nullable | Description |
|---|---|---:|---|
| `customer_id` | `int` | No | Customer business key |
| `customer_name` | `varchar(100)` | No | Customer display name |
| `email` | `varchar(200)` | Yes | Customer email address |
| `city` | `varchar(100)` | No | Customer city |
| `state_code` | `varchar(10)` | No | State or region code |
| `customer_segment` | `varchar(50)` | No | Customer classification |
| `created_at` | `datetime2(3)` | No | Record creation timestamp |
| `updated_at` | `datetime2(3)` | No | Last update timestamp |

### Example Rows

| customer_id | customer_name | city | state_code | customer_segment |
|---:|---|---|---|---|
| 1 | Northwind Retail Co. | Saltillo | COA | Corporate |
| 2 | Sierra Bikes | Monterrey | NL | Small Business |
| 3 | Laguna Home Goods | Torreon | COA | Consumer |
| 4 | Capital Market MX | Mexico City | CDMX | Corporate |

## 7. Dataset: `products`

### Purpose

Stores product attributes used for product-level and category-level reporting.

### Expected ADLS Path

```text
curated/retail/products/
```

### Proposed Schema

| Column | Type | Nullable | Description |
|---|---|---:|---|
| `product_id` | `int` | No | Product business key |
| `product_name` | `varchar(150)` | No | Product name |
| `category` | `varchar(80)` | No | Product category |
| `unit_price` | `decimal(12,2)` | No | Current unit price |
| `is_active` | `bit` | No | Product active flag |
| `created_at` | `datetime2(3)` | No | Record creation timestamp |
| `updated_at` | `datetime2(3)` | No | Last update timestamp |

### Example Rows

| product_id | product_name | category | unit_price | is_active |
|---:|---|---|---:|---:|
| 101 | Mechanical Keyboard | Accessories | 89.90 | 1 |
| 102 | Wireless Mouse | Accessories | 29.90 | 1 |
| 103 | 27-inch Monitor | Displays | 249.00 | 1 |
| 104 | USB-C Docking Station | Accessories | 119.00 | 1 |

## 8. Dataset: `orders`

### Purpose

Stores order header information used for date, customer, payment, and order status analysis.

### Expected ADLS Path

```text
curated/retail/orders/
```

### Proposed Schema

| Column | Type | Nullable | Description |
|---|---|---:|---|
| `order_id` | `int` | No | Order business key |
| `customer_id` | `int` | No | Related customer |
| `order_date` | `date` | No | Business order date |
| `order_status` | `varchar(30)` | No | Order lifecycle status |
| `payment_status` | `varchar(30)` | No | Payment lifecycle status |
| `order_total` | `decimal(12,2)` | No | Total order amount |
| `created_at` | `datetime2(3)` | No | Record creation timestamp |
| `updated_at` | `datetime2(3)` | No | Last update timestamp |

### Allowed `order_status` Values

| Status | Meaning |
|---|---|
| `COMPLETED` | Order completed successfully |
| `PAID` | Order paid but not yet completed |
| `PENDING` | Order pending payment or processing |
| `CANCELLED` | Order cancelled |
| `REFUNDED` | Order refunded |

### Allowed `payment_status` Values

| Status | Meaning |
|---|---|
| `APPROVED` | Payment approved |
| `PENDING` | Payment pending |
| `DECLINED` | Payment declined |
| `REFUNDED` | Payment refunded |

### Example Rows

| order_id | customer_id | order_date | order_status | payment_status | order_total |
|---:|---:|---|---|---|---:|
| 1001 | 1 | 2026-06-01 | COMPLETED | APPROVED | 368.80 |
| 1002 | 2 | 2026-06-01 | COMPLETED | APPROVED | 249.00 |
| 1003 | 3 | 2026-06-02 | PENDING | PENDING | 119.00 |
| 1004 | 1 | 2026-06-03 | REFUNDED | REFUNDED | 89.90 |

## 9. Dataset: `order_items`

### Purpose

Stores line-level order detail used for product sales, category sales, and revenue calculations.

### Expected ADLS Path

```text
curated/retail/order_items/
```

### Proposed Schema

| Column | Type | Nullable | Description |
|---|---|---:|---|
| `order_item_id` | `int` | No | Order line identifier |
| `order_id` | `int` | No | Related order |
| `product_id` | `int` | No | Related product |
| `quantity` | `int` | No | Quantity sold |
| `unit_price` | `decimal(12,2)` | No | Unit price at time of order |
| `line_total` | `decimal(12,2)` | No | Quantity multiplied by unit price |
| `created_at` | `datetime2(3)` | No | Record creation timestamp |
| `updated_at` | `datetime2(3)` | No | Last update timestamp |

### Business Rule

For each row:

```text
line_total = quantity * unit_price
```

### Example Rows

| order_item_id | order_id | product_id | quantity | unit_price | line_total |
|---:|---:|---:|---:|---:|---:|
| 1 | 1001 | 101 | 2 | 89.90 | 179.80 |
| 2 | 1001 | 102 | 3 | 29.90 | 89.70 |
| 3 | 1002 | 103 | 1 | 249.00 | 249.00 |
| 4 | 1003 | 104 | 1 | 119.00 | 119.00 |

## 10. Derived Analytical Outputs

The MVP may create reporting views and optional CETAS outputs from the curated datasets.

Derived outputs are not considered source datasets.

Examples:

| Output | Type | Purpose |
|---|---|---|
| `rpt.vw_sales_by_date` | View | Daily sales totals |
| `rpt.vw_sales_by_customer` | View | Customer revenue ranking |
| `rpt.vw_sales_by_product` | View | Product revenue ranking |
| `rpt.vw_sales_by_city` | View | City-level sales |
| `rpt.vw_order_status_summary` | View | Order status distribution |
| `serving/retail/sales_by_date/` | CETAS output | Materialized analytical result |

## 11. Expected Analytical Queries

The data model must support the following query patterns:

### Sales by Date

Group completed or paid orders by `order_date` and calculate total revenue.

### Sales by Customer

Join `customers`, `orders`, and `order_items` to calculate customer-level revenue.

### Sales by Product

Join `products` and `order_items` to calculate product-level revenue and quantity sold.

### Sales by City

Join `customers` and `orders` to calculate revenue by city and state.

### Order Status Summary

Group orders by `order_status` and `payment_status`.

### Data Quality Checks

Validate row counts, duplicate keys, orphan records, negative amounts, invalid statuses, and `line_total` mismatches.

## 12. Data Quality Expectations

The curated dataset should be mostly clean.

Expected validation results:

| Check | Expected Result |
|---|---|
| Duplicate customer IDs | 0 |
| Duplicate product IDs | 0 |
| Duplicate order IDs | 0 |
| Duplicate order item IDs | 0 |
| Orders without matching customer | 0 |
| Order items without matching order | 0 |
| Order items without matching product | 0 |
| Negative order totals | 0 |
| Negative line totals | 0 |
| Invalid order statuses | 0 |
| Invalid payment statuses | 0 |
| Line total mismatches | 0 |

The project may include validation queries to prove that the serving layer can detect these conditions.

## 13. Parquet and SQL Type Alignment

The generated Parquet files should preserve consistent column types so they can be queried reliably from Synapse Serverless SQL.

Recommended type alignment:

| Logical Type | SQL Type |
|---|---|
| Integer identifiers | `int` |
| Names and categories | `varchar` |
| Dates | `date` |
| Timestamps | `datetime2(3)` |
| Monetary values | `decimal(12,2)` |
| Flags | `bit` |

Avoid inconsistent typing such as storing numeric values as text.

## 14. Partitioning Strategy

For the MVP, partitioning is optional.

Recommended initial approach:

```text
No complex partitioning for the first version.
```

Reason:

- The dataset is small.
- The project objective is SQL serving, not storage optimization.
- Simple folders are easier to explain and validate.

A future improvement may introduce partitioning by:

```text
order_year
order_month
order_date
```

## 15. Naming Convention

Dataset folder names should use lowercase snake case:

```text
customers
products
orders
order_items
```

SQL external tables should use the `ext` schema:

```text
ext.customers
ext.products
ext.orders
ext.order_items
```

Reporting views should use the `rpt` schema:

```text
rpt.vw_sales_by_date
rpt.vw_sales_by_customer
rpt.vw_sales_by_product
rpt.vw_sales_by_city
rpt.vw_order_status_summary
```

Audit views or validation queries should use the `audit` schema:

```text
audit.vw_row_counts
audit.vw_data_quality_checks
```

## 16. MVP Boundary

Included:

- Controlled retail sample data.
- Curated Parquet files in ADLS Gen2.
- SQL external tables over the curated files.
- Reporting views.
- Analytical queries.
- Data quality queries.
- Optional CETAS output.

Not included:

- Full data warehouse modeling.
- Slowly Changing Dimensions.
- Delta Lake transaction history.
- Power BI semantic model.
- Real-time data.
- Full production monitoring.
- Enterprise governance.

## 17. Success Criteria

This source data model is successful when:

1. The model supports the planned analytical queries.
2. The schema maps cleanly to Synapse Serverless SQL external tables.
3. The dataset can be generated or prepared reproducibly.
4. The curated files can be uploaded to ADLS Gen2.
5. Synapse Serverless SQL can expose the files through external tables.
6. Data quality queries can validate the model.
7. The model remains simple enough for portfolio documentation and interview explanation.

## 18. Next Step

After this document is committed, create a data generation strategy.

Recommended next artifact:

```text
scripts/generate_sample_data.py
```

The script should generate controlled synthetic retail data and write the datasets as Parquet files for upload to ADLS Gen2.
