# Evidence Capture Guide

**Project:** `azure-synapse-serverless-serving-layer`  
**Document:** Evidence Capture Guide  
**Status:** Documentation and Evidence Packaging

## 1. Purpose

This document defines how execution evidence should be captured, named, reviewed, and included in the public repository.

The goal is to prove that the Synapse Serverless SQL serving layer works end to end while keeping all evidence public-safe.

## 2. Evidence Principles

Evidence should be:

- Public-safe.
- Readable.
- Focused on one milestone at a time.
- Numbered consistently.
- Free from secrets and sensitive identifiers.
- Useful for recruiter and technical review.
- Connected to scripts and documentation.

Avoid evidence that is visually noisy, redundant, or exposes private details.

## 3. Sensitive Information to Hide

Do not publish screenshots showing:

- Subscription IDs.
- Tenant IDs.
- Object IDs.
- Storage account keys.
- SAS tokens.
- SQL admin passwords.
- Private email addresses.
- Personal local machine names.
- Full Azure billing pages.
- Connection strings.
- Access tokens.

If a screenshot is useful but contains sensitive fields, crop or blur the sensitive area before committing it.

## 4. Recommended Evidence Folder Structure

Use this structure:

```text
evidence/
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

## 5. Recommended Screenshot List

### 01 — Synapse Workspace

Recommended screenshot:

```text
01_synapse_workspace_ready.png
```

Should show:

- Synapse workspace exists.
- Workspace region.
- Serverless endpoint if safe or partially cropped.
- No subscription ID or object ID.

### 02 — ADLS Curated Data

Recommended screenshot:

```text
02_adls_curated_retail_files.png
```

Should show:

- Container.
- `curated/retail/` folder.
- Customers, products, orders and order_items Parquet folders.

### 03 — SQL Database

Recommended screenshot:

```text
03_synapse_database_created.png
```

Should show:

- `synapse_serving_demo` database exists.
- Query result or Synapse Data panel.

### 04 — External Objects

Recommended screenshots:

```text
04_external_data_source_created.png
04_external_file_format_created.png
04_external_tables_created.png
```

Should show:

- `ds_adls_synapse_serving` external data source.
- `ff_parquet` external file format.
- `ext.customers`, `ext.products`, `ext.orders`, `ext.order_items` external tables.

### 05 — External Tables Smoke Test

Recommended screenshot:

```text
05_external_tables_smoke_test_pass.png
```

Should show:

- Row counts for the four external tables.
- Final `PASS` status.

### 06 — Reporting Views

Recommended screenshot:

```text
06_reporting_views_created.png
```

Should show:

- Reporting views created successfully.
- Optional resultset listing the views.

### 07 — Analytical Queries

Recommended screenshots:

```text
07_sales_by_date_query.png
07_top_customers_query.png
07_sales_by_product_query.png
07_sales_by_city_query.png
```

Should show:

- Business analytical output from SQL queries.
- Clear resultsets.

### 08 — Data Quality Queries

Recommended screenshot:

```text
08_data_quality_checks_pass.png
```

Should show:

- Duplicate key checks.
- Orphan record checks.
- Negative amount checks.
- Status validation.
- `PASS` result.

### 09 — CETAS Output

Recommended screenshots:

```text
09_cetas_table_created.png
09_cetas_output_adls_files.png
09_cetas_validation_pass.png
```

Should show:

- CETAS external table exists.
- `serving/retail/sales_by_date_cetas/` output exists in ADLS.
- CETAS validation returns `PASS`.

### 10 — Cost Controls

Recommended screenshot:

```text
10_no_dedicated_pool_or_spark_pool.png
```

Should show, if possible:

- No Dedicated SQL Pool created.
- No Spark Pool created.
- Built-in Serverless SQL used.

## 6. Naming Convention

Use lowercase, numbered, descriptive names:

```text
05_external_tables_smoke_test_pass.png
08_data_quality_checks_pass.png
09_cetas_validation_pass.png
```

Avoid names like:

```text
Screenshot1.png
image.png
final_final.png
```

## 7. Evidence Index Update

Every screenshot added to `evidence/` should be referenced in:

```text
docs/evidence_index.md
```

Each evidence item should include:

- File path.
- What it proves.
- Related script or phase.
- Public-safety status.

## 8. Minimum Evidence Package

The minimum acceptable public evidence package is:

```text
01_synapse_workspace_ready.png
02_adls_curated_retail_files.png
04_external_tables_created.png
05_external_tables_smoke_test_pass.png
06_reporting_views_created.png
07_analytical_queries_results.png
08_data_quality_checks_pass.png
09_cetas_validation_pass.png
10_no_dedicated_pool_or_spark_pool.png
```

## 9. Final Evidence QA

Before project closeout:

- Open every screenshot from GitHub.
- Confirm it renders clearly.
- Confirm no sensitive values are visible.
- Confirm filenames match the evidence index.
- Confirm evidence supports claims made in README and docs.

