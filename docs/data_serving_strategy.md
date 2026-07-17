# Data Serving Strategy

**Project:** `azure-synapse-serverless-serving-layer`  
**Document:** Data Serving Strategy  
**Status:** Phase 6 — Documentation and Evidence Package  
**Last updated:** 2026-07-17

## 1. Purpose

This document explains how the project exposes curated data lake assets for SQL-based analytical consumption using Azure Synapse Serverless SQL.

The serving strategy focuses on making Parquet files stored in Azure Data Lake Storage Gen2 queryable through a structured SQL interface.

The project is not an ingestion pipeline and is not a transformation pipeline.

The project demonstrates the serving layer that sits after upstream data preparation.

```text
Curated Parquet files → Synapse Serverless SQL → External Tables → Reporting Views → Analytical Queries
```

## 2. Serving Layer Objective

The goal of the serving layer is to make curated lake data easier to consume through SQL.

Instead of requiring analytical users to understand lake paths, file formats, or folder structures, Synapse Serverless SQL exposes the data through:

- External data source
- External file format
- External tables
- Reporting views
- Data quality queries
- Optional CETAS output

## 3. Source Data Positioning

The project uses controlled synthetic retail data stored as Parquet files in ADLS Gen2.

Current curated datasets:

| Dataset | Purpose |
|---|---|
| `customers` | Customer attributes and geography |
| `products` | Product catalog |
| `orders` | Order header data |
| `order_items` | Order line details |

Current ADLS layout:

```text
curated/retail/customers/
curated/retail/products/
curated/retail/orders/
curated/retail/order_items/
```

In a production architecture, these curated Parquet assets could be produced by an upstream Databricks Gold layer, Azure Data Factory transformation process, Fabric Lakehouse, or another trusted preparation workflow.

## 4. SQL Object Strategy

The project separates SQL objects by responsibility.

| Schema | Role |
|---|---|
| `ext` | External tables over curated lake files |
| `rpt` | Reporting views and CETAS analytical outputs |
| `audit` | Data validation and quality-oriented queries/views |

This separation keeps the serving model readable and interview-friendly.

## 5. External Tables

External tables provide a stable SQL surface over Parquet files in ADLS Gen2.

Current external tables:

```text
ext.customers
ext.products
ext.orders
ext.order_items
```

External tables are useful because they let consumers query lake files using familiar SQL object names.

Important design note:

External tables in Synapse Serverless SQL are schema-on-read objects. The project does not enforce `NOT NULL` constraints in external table DDL. Logical nullability rules are documented in the data model and validated through SQL checks.

## 6. Reporting Views

Reporting views provide business-friendly query surfaces over external tables.

Current reporting views:

```text
rpt.vw_revenue_order_lines
rpt.vw_sales_by_date
rpt.vw_sales_by_customer
rpt.vw_sales_by_product
rpt.vw_sales_by_city
rpt.vw_order_status_summary
```

The reporting views hide join logic and provide reusable analytical outputs.

## 7. Data Quality Strategy

The serving layer includes SQL-based quality checks to validate that curated data can be trusted for reporting.

Current validation areas:

- Row counts
- Duplicate business keys
- Orphan records
- Invalid statuses
- Negative amounts
- Line total mismatches
- Order total mismatches

The goal is not to replace upstream data quality enforcement.

The goal is to prove that the serving layer can expose and validate analytical readiness through SQL.

## 8. CETAS Strategy

The project uses CETAS to materialize a reporting output from Synapse Serverless SQL back into ADLS Gen2.

Current CETAS output:

```text
rpt.sales_by_date_cetas
```

Current ADLS output path:

```text
serving/retail/sales_by_date_cetas/run_id=manual_001/
```

CETAS demonstrates that the serving layer can produce reusable curated outputs, not only read existing files.

Important operational note:

CETAS does not overwrite existing output folders. Re-runs require either a new output path or cleanup of the previous folder.

## 9. Cost-Aware Serving Principles

The serving layer follows cost-aware principles:

- Use serverless SQL instead of dedicated SQL pools for the MVP.
- Use small controlled datasets.
- Prefer Parquet for columnar storage and reduced scan footprint.
- Avoid unnecessary `SELECT *` in analytical examples.
- Query only required columns where practical.
- Keep CETAS outputs small.
- Avoid always-on compute services.

## 10. Public Portfolio Positioning

This project demonstrates the ability to expose curated Data Lake assets through a SQL serving layer.

Professional narrative:

```text
I built a SQL serving layer over Azure Data Lake Storage Gen2 using Azure Synapse Serverless SQL. The project exposes curated Parquet datasets through external tables and analytical views, demonstrates cost-aware querying patterns, validates data quality from the serving layer, and materializes a CETAS output back to the lake.
```

## 11. Relationship to the Learning Lab

This repository is the portfolio-facing implementation project.

A separate private learning repository is planned:

```text
azure-synapse-learning-lab
```

The learning lab will reinforce hands-on fluency through exercises, attempts, troubleshooting, and interview-defense practice.

This separation keeps the public project clean while preserving a dedicated dojo for skill-building.
