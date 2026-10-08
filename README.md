<h1 align="center">Azure Synapse Serverless Serving Layer</h1>

<p align="center">
  SQL serving over curated Parquet in ADLS Gen2 using Synapse Serverless SQL, external tables, reporting views, data-quality queries, and CETAS.
</p>

<p align="center">
  <a href="docs/architecture_and_scope.md">Architecture</a> |
  <a href="docs/data_serving_strategy.md">Serving Strategy</a> |
  <a href="docs/synapse_object_model.md">SQL Object Model</a> |
  <a href="docs/evidence_index.md">Evidence</a> |
  <a href="docs/cost_controls.md">Cost Controls</a>
</p>

---

## The problem

Curated Parquet files in a Data Lake are useful to engineers, but many analytical consumers still need a stable SQL interface.

A serving layer must answer:

- How can lake files be exposed without copying them into provisioned SQL compute?
- How can reusable SQL objects hide folder-level storage details?
- Can business-facing views answer common analytical questions?
- Can data-quality checks be performed from the serving layer itself?
- Can selected query outputs be materialized back to the lake?
- How can all of this remain cost-aware for a small analytical workload?

This project focuses on that consumption layer.

## The idea

The implementation uses **Azure Synapse Serverless SQL as a thin serving layer over curated Parquet in ADLS Gen2**.

```text
Curated Parquet in ADLS Gen2
        ↓
Synapse Serverless SQL
        ↓
External data source + Parquet file format
        ↓
External tables
        ↓
Reporting views
        ↓
Analytical queries + data-quality checks
        ↓
CETAS serving output back to ADLS Gen2
```

The project deliberately avoids Dedicated SQL Pool and Spark because neither is required to demonstrate this serving pattern.

## At a glance

| Area | Implementation |
|---|---|
| Cloud platform | Microsoft Azure |
| Serving engine | Synapse Serverless SQL |
| Storage | Azure Data Lake Storage Gen2 |
| Curated format | Parquet |
| SQL access | External data source + external file format |
| Serving objects | External tables + reporting views |
| Analytics | Business-facing SQL queries |
| Data quality | 13 SQL validation checks |
| Materialization | CETAS output back to ADLS Gen2 |
| Security helper | Workspace Managed Identity + Storage Blob Data Reader script |
| Cost model | Serverless / pay-per-query; no Dedicated SQL Pool or Spark Pool |
| Implementation status | Completed technical MVP |
| Public screenshot evidence | Partial; implementation artifacts are the primary public proof |

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

The public proof model for this repository is intentionally split into two categories:

1. **Versioned implementation artifacts** — the primary proof for the SQL serving layer.
2. **Public-safe screenshots** — supplemental visual evidence where it was actually captured and committed.

The repository currently includes implementation artifacts for:

- external tables;
- reporting views;
- analytical queries;
- data-quality checks;
- CETAS materialization;
- CETAS validation;
- sample-data generation and curated Parquet files;
- Managed Identity / RBAC helper automation.

The public screenshot package is **partial**, not complete. One ADLS upload screenshot is currently versioned under `evidence/01_adls_structure/`.

See [docs/evidence_index.md](docs/evidence_index.md) for the exact claims-to-proof map.

Evidence must remain public-safe: no storage keys, passwords, SAS tokens, connection strings, subscription IDs, tenant IDs, object IDs, private emails, or sensitive local-machine information.

## Status

```text
Technical MVP: Completed
SQL implementation artifacts: Completed
Documentation packaging: Completed
Public screenshot evidence: Partial
Repository standardization: In progress
```

The incomplete screenshot pack is an explicit evidence limitation; it does not change the implemented SQL scope documented in the versioned scripts.

## Companion Learning Lab

This portfolio project has a companion private dojo repository:

```text
azure-synapse-learning-lab
```

The learning lab is used for guided practice, attempts, troubleshooting, repetition and interview-defense preparation. It is intentionally separate from the public portfolio repository so the main project remains clean and recruiter-facing.

## Next Steps

Possible future enhancements are documented in [docs/future_improvements.md](docs/future_improvements.md).

The companion `azure-synapse-learning-lab` is maintained separately so practice work does not dilute the public portfolio repository.
