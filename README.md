# Azure Synapse Serverless Serving Layer

## Overview

This project demonstrates a SQL serving layer over curated data stored in Azure Data Lake Storage Gen2 using Azure Synapse Serverless SQL.

The goal is to expose curated Parquet datasets through external tables, reporting views, analytical SQL queries, and a CETAS serving output so downstream users can consume Data Lake assets through a familiar SQL interface.

This project is part of an Azure Data Engineering portfolio focused on practical, recruiter-facing, and technically defensible cloud data engineering patterns.

## Professional Narrative

I built a SQL serving layer over Azure Data Lake Storage Gen2 using Azure Synapse Serverless SQL. The project exposes curated Parquet datasets through external tables and analytical views, demonstrates data quality checks from SQL, materializes a curated CETAS output back to the lake, and documents cost-aware querying practices for downstream analytics and BI consumption.

## Business Problem

A retail business has curated customer, product, order, and order item datasets stored in a Data Lake as Parquet files.

Analytical users need SQL access to answer business questions such as:

- What are total sales by date?
- Which customers generate the most revenue?
- Which products sell the most?
- Which cities generate the highest revenue?
- What is the distribution of order and payment statuses?
- Are there basic data quality issues visible from the serving layer?

The solution creates a structured SQL access layer so users do not need to understand raw lake folder paths or file-level storage details.

## Target Architecture

```text
Controlled sample data
        ↓
Parquet files in ADLS Gen2
        ↓
Azure Synapse Serverless SQL
        ↓
External data source
        ↓
External file format
        ↓
External tables
        ↓
Reporting views
        ↓
Analytical query layer
        ↓
Data quality queries
        ↓
CETAS serving output
```

## Implemented Scope

This MVP implements:

- Azure Data Lake Storage Gen2 container for curated and serving data.
- Controlled synthetic retail datasets generated locally.
- Parquet files uploaded to ADLS Gen2.
- Azure Synapse Analytics workspace using the built-in Serverless SQL pool.
- Synapse Serverless SQL database.
- External data source pointing to ADLS Gen2.
- External file format for Parquet.
- External tables over curated lake files.
- Reporting views for analytical consumption.
- Analytical SQL query examples.
- Data quality validation queries.
- CETAS output materialized back to ADLS Gen2.
- Cost-control documentation.
- Public-safe evidence package.

## Out of Scope

The MVP intentionally excludes:

- Dedicated SQL Pool.
- Spark Pools.
- Full Power BI dashboard.
- Advanced semantic model.
- Private endpoints.
- Microsoft Purview lineage.
- Full CI/CD.
- Infrastructure as Code.
- Enterprise security hardening.
- Production monitoring.
- Real-time ingestion.

These items are documented as future improvements.

## Data Model

The project uses a controlled retail model with four curated datasets:

| Dataset | Grain | Purpose |
|---|---|---|
| `customers` | One row per customer | Customer and geography reporting |
| `products` | One row per product | Product and category reporting |
| `orders` | One row per order header | Order status, payment status, date and customer analysis |
| `order_items` | One row per order line | Product-level revenue and quantity analysis |

Logical relationships:

```text
customers.customer_id  → orders.customer_id
orders.order_id       → order_items.order_id
products.product_id   → order_items.product_id
```

## ADLS Gen2 Layout

The project uses the following logical lake layout:

```text
synapse-serving/
├── curated/
│   └── retail/
│       ├── customers/
│       │   └── customers.parquet
│       ├── products/
│       │   └── products.parquet
│       ├── orders/
│       │   └── orders.parquet
│       └── order_items/
│           └── order_items.parquet
│
├── serving/
│   └── retail/
│       └── sales_by_date_cetas/
│           └── run_id=manual_001/
│
└── evidence/
```

## Synapse SQL Object Model

The project creates the database:

```text
synapse_serving_demo
```

Recommended schemas:

| Schema | Purpose |
|---|---|
| `ext` | External tables over curated Parquet files |
| `rpt` | Reporting views and CETAS output |
| `audit` | Optional validation and audit objects |

Implemented external tables:

```text
ext.customers
ext.products
ext.orders
ext.order_items
```

Implemented reporting views:

```text
rpt.vw_revenue_order_lines
rpt.vw_sales_by_date
rpt.vw_sales_by_customer
rpt.vw_sales_by_product
rpt.vw_sales_by_city
rpt.vw_order_status_summary
```

Implemented CETAS output:

```text
rpt.sales_by_date_cetas
```

## SQL Script Execution Order

Run the SQL scripts in this order from Synapse Studio using the built-in Serverless SQL pool:

| Script | Purpose |
|---|---|
| `sql/00_create_database.sql` | Create the project database and schemas |
| `sql/01_create_external_data_source.sql` | Create the external data source to ADLS Gen2 |
| `sql/02_create_external_file_format.sql` | Create the Parquet external file format |
| `sql/03_create_external_tables.sql` | Create external tables over curated Parquet datasets |
| `sql/04_smoke_test_external_tables.sql` | Validate external table row counts |
| `sql/05_create_reporting_views.sql` | Create analytical reporting views |
| `sql/06_analytical_queries.sql` | Run business-facing analytical queries |
| `sql/07_data_quality_queries.sql` | Run serving-layer data quality checks |
| `sql/08_cetas_output.sql` | Create CETAS output in ADLS Gen2 |
| `sql/09_validate_cetas_output.sql` | Validate CETAS metadata, row counts and business totals |

## Validation Summary

The project validates the following milestones:

| Validation Area | Expected Result |
|---|---|
| Serverless SQL smoke test | Query returns timestamp successfully |
| Database creation | `synapse_serving_demo` exists |
| External data source | ADLS Gen2 location registered |
| External file format | Parquet format registered |
| External tables | All four curated datasets exposed |
| External table smoke test | Row counts match expected dataset counts |
| Reporting views | Analytical views return expected business outputs |
| Analytical queries | Business questions are answerable through SQL |
| Data quality checks | Validation status returns `PASS` |
| CETAS output | Serving output is materialized to ADLS Gen2 |
| CETAS validation | Output row counts and totals match source view |

## Key Technical Lessons

During implementation, the following Synapse Serverless behaviors were observed and documented:

- External table column definitions should not use `NOT NULL`; nullability remains a logical data contract validated through SQL checks.
- Serverless SQL external tables are schema-on-read objects over lake files.
- System catalog queries such as `sys.external_tables` should be kept separate from distributed external data queries when validation scripts become complex.
- CETAS does not overwrite an existing output folder; reruns require a new output location or cleanup of the previous folder.
- Column names in CETAS validation must match the actual projected schema from the source view.

## Cost-Control Approach

The project remains cost-aware by:

- Using Synapse Serverless SQL instead of Dedicated SQL Pool.
- Avoiding Spark Pools.
- Using small synthetic datasets.
- Storing curated files in Parquet format.
- Selecting only required columns in analytical examples.
- Keeping CETAS output small.
- Avoiding always-on compute.
- Documenting future production enhancements separately from MVP scope.

## Repository Structure

```text
README.md
LICENSE
.gitignore
docs/
sql/
sample_data/
scripts/
diagrams/
evidence/
```

## Documentation

| Document | Purpose |
|---|---|
| `docs/architecture_and_scope.md` | Defines project scope, architecture, MVP boundaries and implementation plan |
| `docs/source_data_model.md` | Documents the controlled retail data model |
| `docs/adls_folder_structure.md` | Documents the ADLS Gen2 layout |
| `docs/data_serving_strategy.md` | Explains the serving-layer design and consumption model |
| `docs/synapse_object_model.md` | Documents SQL database, schemas, external objects, views and CETAS output |
| `docs/query_examples.md` | Documents analytical SQL examples and validation queries |
| `docs/cost_controls.md` | Documents cost-aware query and service usage practices |
| `docs/evidence_index.md` | Indexes public-safe execution evidence |
| `docs/known_limitations.md` | Documents MVP limitations honestly |
| `docs/future_improvements.md` | Documents possible production enhancements |
| `docs/certification_alignment.md` | Maps project concepts to Microsoft data engineering certification-related skills |

## Evidence

Evidence should be stored under:

```text
evidence/
```

Recommended evidence areas:

```text
01_synapse_workspace/
02_adls_curated_data/
03_sql_database/
04_external_objects/
05_external_tables_smoke_test/
06_reporting_views/
07_analytical_queries/
08_data_quality_queries/
09_cetas_output/
10_cost_controls/
```

Evidence must be public-safe. Do not include storage keys, passwords, SAS tokens, connection strings, subscription IDs, tenant IDs, object IDs, private emails or sensitive local machine information.

## Status

```text
Functional MVP completed.
Documentation and evidence packaging in progress.
```

## Companion Learning Lab

This portfolio project has a companion private dojo repository:

```text
azure-synapse-learning-lab
```

The learning lab is used for guided practice, attempts, troubleshooting, repetition and interview-defense preparation. It is intentionally separate from the public portfolio repository so the main project remains clean and recruiter-facing.

## Next Steps

1. Organize and sanitize execution evidence.
2. Complete final documentation review.
3. Validate README links and evidence links.
4. Scan repository for secrets or sensitive values.
5. Complete final public repository QA.
6. Update the private roadmap repository.
7. Start the companion `azure-synapse-learning-lab` dojo.
