# Synapse Object Model

**Project:** `azure-synapse-serverless-serving-layer`  
**Document:** Synapse Object Model  
**Status:** Phase 6 — Documentation and Evidence Package  
**Last updated:** 2026-07-16

## 1. Purpose

This document describes the SQL object model implemented in Azure Synapse Serverless SQL for the `azure-synapse-serverless-serving-layer` project.

The objective of the object model is to expose curated Parquet files stored in Azure Data Lake Storage Gen2 as SQL-accessible assets for analytical consumption.

The serving layer follows this pattern:

```text
ADLS Gen2 curated Parquet files
        ↓
Synapse Serverless SQL external data source
        ↓
External file format
        ↓
External tables
        ↓
Reporting views
        ↓
Analytical queries and optional CETAS output
```

## 2. Database

The project uses a dedicated Synapse Serverless SQL database:

```text
synapse_serving_demo
```

This database isolates the portfolio project objects from `master` and provides a clean namespace for external tables, reporting views, and validation queries.

## 3. Schemas

The database uses three logical schemas:

| Schema | Purpose |
|---|---|
| `ext` | External tables over curated Parquet files in ADLS Gen2 |
| `rpt` | Reporting views and CETAS serving outputs |
| `audit` | Optional audit or validation objects |

## 4. External Data Source

The external data source points Synapse Serverless SQL to the ADLS Gen2 filesystem used by the project.

Object name:

```text
ds_adls_synapse_serving
```

Location pattern:

```text
abfss://<container_name>@<storage_account_name>.dfs.core.windows.net/
```

For the MVP, the external data source points to the project filesystem that contains:

```text
curated/
serving/
evidence/
```

## 5. External File Format

The project uses Parquet as the curated file format.

Object name:

```text
ff_parquet
```

Format type:

```text
PARQUET
```

Parquet was selected because it is columnar, efficient for analytical queries, and appropriate for SQL serving over curated datasets.

## 6. External Tables

The `ext` schema contains external tables over the curated retail datasets.

| External Table | ADLS Folder | Purpose |
|---|---|---|
| `ext.customers` | `curated/retail/customers/` | Customer attributes and location |
| `ext.products` | `curated/retail/products/` | Product catalog and category attributes |
| `ext.orders` | `curated/retail/orders/` | Order headers and lifecycle status |
| `ext.order_items` | `curated/retail/order_items/` | Order line-level sales detail |

These tables are schema-on-read objects. They do not store data inside Synapse. They expose files stored in ADLS Gen2 through SQL metadata.

## 7. External Table Nullability Note

Synapse Serverless SQL external tables do not enforce `NOT NULL` constraints in the external table DDL.

Therefore, the project keeps nullability rules in documentation as a logical data contract, but the implemented external table definitions do not include `NOT NULL`.

This distinction is intentional:

```text
source_data_model.md
    Defines expected nullability and business rules.

sql/03_create_external_tables.sql
    Defines schema-on-read external tables without NOT NULL constraints.

sql/07_data_quality_queries.sql
    Validates data quality rules from SQL.
```

This keeps the serving layer compatible with Synapse Serverless SQL while still preserving the business data quality expectations.

## 8. Reporting Views

The `rpt` schema contains analytical views designed for consumption by analysts, BI tools, or downstream SQL users.

| View | Purpose |
|---|---|
| `rpt.vw_revenue_order_lines` | Base revenue view joining orders, order items, products, and customers |
| `rpt.vw_sales_by_date` | Daily sales summary |
| `rpt.vw_sales_by_customer` | Customer-level revenue and order summary |
| `rpt.vw_sales_by_product` | Product-level revenue and quantity summary |
| `rpt.vw_sales_by_city` | City and state-level revenue summary |
| `rpt.vw_order_status_summary` | Order status and payment status distribution |

The reporting views simplify query access so consumers do not need to know the underlying folder structure or join logic.

## 9. CETAS Output

The project includes a CETAS output that materializes an analytical result back into ADLS Gen2.

External table:

```text
rpt.sales_by_date_cetas
```

Output folder pattern:

```text
serving/retail/sales_by_date_cetas/run_id=manual_001/
```

The CETAS output demonstrates that Synapse Serverless SQL can not only query lake files, but also write curated analytical results back to the lake.

## 10. CETAS Execution Note

CETAS does not overwrite an existing output folder.

If the output path already contains files, rerunning the CETAS script may fail. Re-execution requires one of the following options:

1. Use a new output path, such as `run_id=manual_002/`.
2. Delete the previous output folder from ADLS Gen2 before rerunning.
3. Drop and recreate the external table if needed.

This behavior is documented as part of the operational limitations of the MVP.

## 11. Validation Queries

The project includes validation scripts for each major implementation checkpoint.

| Script | Validation Purpose |
|---|---|
| `04_smoke_test_external_tables.sql` | Confirms external tables can read the Parquet datasets |
| `06_analytical_queries.sql` | Confirms reporting views answer business questions |
| `07_data_quality_queries.sql` | Confirms key data quality checks pass |
| `09_validate_cetas_output.sql` | Confirms the CETAS output was created and matches the source view |

## 12. Metadata Query Limitation

During CETAS validation, the project avoids mixing system catalog views such as `sys.external_tables` with distributed queries over external data in the same query block.

Instead, validation is split into separate resultsets:

```text
Metadata validation against sys.external_tables
External data validation against reporting views and CETAS output
Business sanity validation against aggregated output
```

This approach avoids unsupported distributed processing behavior and makes the validation easier to read.

## 13. Implemented Script Sequence

Current SQL script sequence:

```text
sql/00_create_database.sql
sql/01_create_external_data_source.sql
sql/02_create_external_file_format.sql
sql/03_create_external_tables.sql
sql/04_smoke_test_external_tables.sql
sql/05_create_reporting_views.sql
sql/06_analytical_queries.sql
sql/07_data_quality_queries.sql
sql/08_cetas_output.sql
sql/09_validate_cetas_output.sql
```

## 14. Success Criteria

The Synapse object model is successful when:

1. The `synapse_serving_demo` database exists.
2. The `ext`, `rpt`, and optional `audit` schemas exist.
3. The external data source points to the ADLS Gen2 filesystem.
4. The Parquet external file format exists.
5. External tables expose the curated datasets.
6. Reporting views return analytical results.
7. Data quality validation returns `PASS`.
8. CETAS materializes an analytical output back to ADLS Gen2.
9. CETAS validation returns `PASS`.

## 15. Professional Value

This object model demonstrates a practical SQL serving layer over a data lake.

It shows that curated lake assets can be exposed through SQL objects without provisioning a dedicated SQL pool, enabling analytical consumption while keeping the architecture cost-aware and portfolio-friendly.
