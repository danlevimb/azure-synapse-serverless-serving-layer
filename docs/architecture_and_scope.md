# Architecture and Scope

**Project:** `azure-synapse-serverless-serving-layer`
**Status:** Phase 0 — Architecture and Scope Definition
**Last updated:** 2026-07-13
**Roadmap role:** Analytical serving / SQL serving layer

## 1. Project Objective

Build a portfolio-ready Azure Synapse Serverless SQL project that exposes curated data lake assets through a SQL-based serving layer.

The project demonstrates how analytical consumers can query structured data stored in Azure Data Lake Storage Gen2 using serverless SQL objects such as external data sources, external file formats, external tables, views, and curated analytical queries.

The goal is not to build another ingestion or transformation pipeline.

The goal is to demonstrate the serving layer that sits after ingestion, orchestration, and Lakehouse processing.

## 2. Professional Narrative

This project answers the following professional question:

```text
Can I expose curated Data Lake assets through a SQL serving layer for analytical consumption?
```

Recruiter-facing narrative:

```text
I built a SQL serving layer over Azure Data Lake Storage Gen2 using Azure Synapse Serverless SQL. The project exposes curated Parquet datasets through external tables and analytical views, demonstrates cost-aware querying patterns, and documents a structured data serving model for downstream analytics and BI consumption.
```

## 3. Portfolio Context

This project follows the completed Azure portfolio foundation:

1. `azure-event-driven-data-pipeline`
2. `azure-adf-incremental-ingestion-framework`
3. `azure-databricks-delta-lakehouse`
4. `azure-databricks-delta-learning-lab`

The previous projects demonstrated ingestion, orchestration, Lakehouse processing, Delta engineering, data quality validation, and private hands-on reinforcement.

This project now focuses on consumption:

```text
Curated data lake assets → Synapse Serverless SQL → Analytical SQL access
```

## 4. Business Scenario

A retail business has curated sales, customer, product, and order datasets stored in Azure Data Lake Storage Gen2 as Parquet files.

Analytical users need SQL access to answer questions such as:

* What are total sales by date?
* Which customers generate the most revenue?
* Which products sell the most?
* Which cities generate the highest order value?
* What is the distribution of order statuses?
* Are there data quality issues visible from the serving layer?

The serving layer should make these datasets easier to query without requiring users to understand raw lake folder structures.

## 5. Target Architecture

The MVP architecture is:

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
Analytical views
        ↓
SQL query examples
        ↓
Optional CETAS curated output
```

## 6. Main Azure Services

### Azure Data Lake Storage Gen2

ADLS Gen2 stores the curated Parquet datasets used by the serving layer.

Expected logical zones:

```text
landing/
curated/
serving/
evidence/
```

For the MVP, the most important zone is:

```text
curated/
```

### Azure Synapse Analytics

Azure Synapse provides the Serverless SQL endpoint used to query data stored in ADLS Gen2.

The project focuses on serverless SQL only.

### Azure Synapse Serverless SQL

Serverless SQL is used to define and query:

* External data sources
* External file formats
* External tables
* SQL views
* Analytical query scripts
* Optional CETAS outputs

## 7. MVP Scope

The MVP includes:

| Area            | Included                                                                                                    |
| --------------- | ----------------------------------------------------------------------------------------------------------- |
| Data source     | Controlled synthetic retail datasets                                                                        |
| Storage         | ADLS Gen2                                                                                                   |
| File format     | Parquet                                                                                                     |
| SQL engine      | Synapse Serverless SQL                                                                                      |
| SQL objects     | Database, schema, credential/data source strategy, external file format, external tables, views             |
| Query layer     | Analytical SQL queries over curated datasets                                                                |
| Optional output | CETAS output for a curated analytical result                                                                |
| Cost controls   | Query design notes to reduce unnecessary data scanned                                                       |
| Evidence        | Screenshots and query outputs proving the serving layer works                                               |
| Documentation   | Architecture, data model, SQL object model, query examples, cost controls, limitations, future improvements |

## 8. Out of Scope

The MVP intentionally excludes:

* Dedicated SQL Pool
* Spark Pools
* Full Power BI dashboard
* Advanced semantic model
* Private endpoints
* Microsoft Purview lineage
* Full CI/CD
* Infrastructure as Code
* Enterprise security hardening
* Production monitoring
* Real-time ingestion
* Streaming analytics
* Databricks job orchestration
* Reusing the completed public Databricks repo as a hard dependency

These items may be documented as future improvements.

## 9. Source Data Strategy

The MVP uses a clean, controlled, project-specific dataset.

Recommended source strategy:

```text
Generate or provide small synthetic retail datasets specifically for this project.
Store them as Parquet files in ADLS Gen2.
Expose them through Synapse Serverless SQL.
```

This keeps the project reproducible and independent from the completed Databricks project.

However, the documentation should explain the real-world connection:

```text
In a production scenario, these curated Parquet assets could be produced by a Databricks Gold layer or another upstream Lakehouse process.
```

## 10. Proposed Dataset

Recommended datasets:

| Dataset                  | Purpose                                   |
| ------------------------ | ----------------------------------------- |
| `customers`              | Customer attributes and location          |
| `products`               | Product catalog                           |
| `orders`                 | Order header data                         |
| `order_items`            | Order line details                        |
| `sales_summary`          | Optional pre-aggregated sales output      |
| `customer_sales_summary` | Optional customer-level analytical output |

Minimum useful analytical questions:

* Sales by date
* Sales by customer
* Sales by product
* Sales by city
* Order status distribution
* Top customers
* Top products
* Data quality checks from SQL

## 11. Proposed ADLS Folder Structure

Recommended folder structure:

```text
curated/
  retail/
    customers/
      part-*.parquet
    products/
      part-*.parquet
    orders/
      part-*.parquet
    order_items/
      part-*.parquet

serving/
  retail/
    sales_by_date/
    sales_by_customer/
    sales_by_product/

evidence/
  01_adls_structure/
  02_synapse_workspace/
  03_external_objects/
  04_query_results/
  05_cetas_output/
  06_cost_controls/
```

## 12. Proposed Synapse SQL Object Model

Recommended SQL object structure:

```text
Database:
  synapse_serving_demo

Schemas:
  ext
  rpt
  audit
```

### `ext` Schema

The `ext` schema contains external tables over curated lake files.

Examples:

```text
ext.customers
ext.products
ext.orders
ext.order_items
```

### `rpt` Schema

The `rpt` schema contains analytical views for consumption.

Examples:

```text
rpt.vw_sales_by_date
rpt.vw_sales_by_customer
rpt.vw_sales_by_product
rpt.vw_sales_by_city
rpt.vw_order_status_summary
```

### `audit` Schema

The `audit` schema contains simple validation views or queries.

Examples:

```text
audit.vw_row_counts
audit.vw_data_quality_checks
```

## 13. SQL Artifacts

The public repository should include SQL scripts under:

```text
sql/
```

Recommended SQL script sequence:

```text
sql/
  00_create_database.sql
  01_create_external_data_source.sql
  02_create_external_file_format.sql
  03_create_external_tables.sql
  04_create_reporting_views.sql
  05_analytical_queries.sql
  06_data_quality_queries.sql
  07_cetas_output.sql
  08_cleanup.sql
```

## 14. Repository Structure

Recommended public repository structure:

```text
azure-synapse-serverless-serving-layer/
│
├── README.md
├── LICENSE
├── .gitignore
│
├── docs/
│   ├── architecture_and_scope.md
│   ├── data_serving_strategy.md
│   ├── source_data_model.md
│   ├── adls_folder_structure.md
│   ├── synapse_object_model.md
│   ├── query_examples.md
│   ├── cost_controls.md
│   ├── known_limitations.md
│   ├── future_improvements.md
│   ├── certification_alignment.md
│   └── evidence_index.md
│
├── sql/
│   ├── 00_create_database.sql
│   ├── 01_create_external_data_source.sql
│   ├── 02_create_external_file_format.sql
│   ├── 03_create_external_tables.sql
│   ├── 04_create_reporting_views.sql
│   ├── 05_analytical_queries.sql
│   ├── 06_data_quality_queries.sql
│   ├── 07_cetas_output.sql
│   └── 08_cleanup.sql
│
├── sample_data/
│   └── README.md
│
├── scripts/
│   └── README.md
│
├── diagrams/
│   └── README.md
│
└── evidence/
    └── README.md
```

## 15. Evidence Strategy

Evidence should prove that the serving layer works end to end.

Recommended evidence:

| Evidence Area         | Purpose                                          |
| --------------------- | ------------------------------------------------ |
| ADLS folder structure | Prove curated files exist in the lake            |
| Synapse workspace     | Prove serverless SQL environment exists          |
| External data source  | Prove SQL can access ADLS                        |
| External file format  | Prove Parquet format definition exists           |
| External tables       | Prove lake files are exposed as SQL tables       |
| Reporting views       | Prove curated analytical views exist             |
| Analytical queries    | Prove business questions can be answered         |
| Data quality queries  | Prove validation can be performed from SQL       |
| CETAS output          | Prove query results can be written back to ADLS  |
| Cost controls         | Prove cost-aware query practices were considered |

## 16. Cost Control Strategy

The project should remain cost-aware.

Cost-control principles:

* Use small synthetic datasets.
* Prefer Parquet over CSV for analytical querying.
* Select only required columns.
* Avoid unnecessary `SELECT *` in analytical examples.
* Use folder organization that supports query pruning when possible.
* Keep CETAS output small.
* Avoid Dedicated SQL Pool.
* Avoid always-on services.
* Delete or pause unnecessary resources after evidence is captured.

## 17. Security and Secrets Boundary

The public repository must not include:

* Storage account keys
* SAS tokens
* Connection strings
* Private endpoint details
* Tenant IDs if not needed
* Subscription IDs
* Personal machine names
* Sensitive screenshots

Authentication details should be documented conceptually without exposing secrets.

## 18. Success Criteria

The MVP is complete when:

1. The public repository is created and structured.
2. ADLS Gen2 contains curated Parquet sample datasets.
3. Synapse Serverless SQL can query the datasets.
4. External data source and external file format are created.
5. External tables expose the curated datasets.
6. Reporting views answer analytical questions.
7. Data quality queries validate basic integrity.
8. Optional CETAS output is created successfully.
9. Evidence screenshots are captured.
10. Documentation explains architecture, data flow, object model, query examples, cost controls, limitations, and future improvements.
11. Public repo QA confirms links, evidence, and sensitive information checks.

## 19. Known Risks

| Risk                                          | Mitigation                                                                                    |
| --------------------------------------------- | --------------------------------------------------------------------------------------------- |
| ADLS permissions block Synapse access         | Validate access early with a small query                                                      |
| Query costs increase due to unnecessary scans | Use small files and cost-aware query examples                                                 |
| External table schema mismatch                | Start with controlled sample data and document schema                                         |
| Project becomes too broad                     | Keep MVP focused on serving layer only                                                        |
| Confusion with Databricks project             | Keep this repo independent and document Databricks only as an upstream production possibility |

## 20. Initial Implementation Plan

### Phase 0 — Architecture and Scope

Deliverables:

* `docs/architecture_and_scope.md`
* Project scope confirmation
* MVP boundaries
* Initial repo structure

### Phase 1 — Repository Foundation

Deliverables:

* Public GitHub repository
* Base folder structure
* README skeleton
* `.gitignore`
* License

### Phase 2 — Source Data and ADLS Layout

Deliverables:

* Controlled sample data strategy
* Parquet files in ADLS Gen2
* ADLS folder evidence

### Phase 3 — Synapse SQL Foundation

Deliverables:

* Database
* Schemas
* External data source
* External file format
* External tables

### Phase 4 — Analytical Views and Queries

Deliverables:

* Reporting views
* Query examples
* Data quality queries

### Phase 5 — CETAS Output

Deliverables:

* CETAS script
* Output folder in ADLS
* Query result validation

### Phase 6 — Documentation and Evidence Package

Deliverables:

* Architecture documentation
* Query examples documentation
* Cost controls documentation
* Evidence index
* Known limitations
* Future improvements

### Phase 7 — Final QA and Portfolio Closeout

Deliverables:

* README polish
* Link validation
* Evidence validation
* Sensitive information check
* Final project closeout
* Roadmap repository update

## 21. Current Next Action

Create the public GitHub repository:

```text
azure-synapse-serverless-serving-layer
```

Then add this document as:

```text
docs/architecture_and_scope.md
```

After that, create the base repository structure and commit the initial architecture scope.
