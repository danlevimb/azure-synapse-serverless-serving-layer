# Evidence Index

**Project:** `azure-synapse-serverless-serving-layer`  
**Document:** Evidence Index  
**Status:** Phase 6 — Documentation and Evidence Package  
**Last updated:** 2026-07-17

## 1. Purpose

This document indexes the public-safe evidence screenshots for the Synapse Serverless SQL serving layer project.

Evidence should prove that the project works end to end:

```text
ADLS Parquet files → Synapse Serverless SQL → External Tables → Reporting Views → Analytical Queries → Data Quality Checks → CETAS Output
```

## 2. Evidence Safety Rules

Before committing screenshots to GitHub, confirm they do not expose:

- Subscription IDs
- Tenant IDs
- Object IDs
- Personal email addresses
- Access keys
- SAS tokens
- Connection strings
- Passwords
- Private machine names
- Sensitive resource metadata not needed for public documentation

If needed, crop or redact screenshots before committing them.

## 3. Recommended Evidence Folder Structure

```text
evidence/
  01_adls_structure/
  02_synapse_workspace/
  03_serverless_sql_database/
  04_external_objects/
  05_smoke_test/
  06_reporting_views/
  07_analytical_queries/
  08_data_quality/
  09_cetas_output/
  10_cost_controls/
```

## 4. Evidence Checklist

| Evidence ID | File Name | Purpose | Status |
|---|---|---|---|
| 01 | `01_adls_curated_parquet_structure.png` | Shows curated Parquet folders in ADLS Gen2 | Pending |
| 02 | `02_synapse_workspace_created.png` | Shows Synapse workspace created successfully | Pending |
| 03 | `03_serverless_sql_first_query.png` | Shows first Built-in Serverless SQL query execution | Pending |
| 04 | `04_database_created.png` | Shows `synapse_serving_demo` database created | Pending |
| 05 | `05_external_data_source_created.png` | Shows ADLS external data source configured | Pending |
| 06 | `06_external_file_format_created.png` | Shows Parquet external file format configured | Pending |
| 07 | `07_external_tables_created.png` | Shows external tables created under `ext` schema | Pending |
| 08 | `08_external_tables_smoke_test_pass.png` | Shows row count smoke test with PASS status | Pending |
| 09 | `09_reporting_views_created.png` | Shows reporting views created successfully | Pending |
| 10 | `10_analytical_queries_results.png` | Shows analytical query results | Pending |
| 11 | `11_data_quality_checks_pass.png` | Shows data quality validation PASS | Pending |
| 12 | `12_cetas_output_created.png` | Shows CETAS external table/output created | Pending |
| 13 | `13_cetas_validation_pass.png` | Shows CETAS validation PASS | Pending |
| 14 | `14_adls_serving_output_folder.png` | Shows CETAS output files in ADLS serving path | Pending |
| 15 | `15_cost_control_no_dedicated_pool.png` | Shows no Dedicated SQL Pool or Spark Pool created | Pending |

## 5. Strongest Evidence for README

The README should use only a small number of high-value screenshots.

Recommended README screenshots:

1. External tables smoke test PASS.
2. Analytical query result from a reporting view.
3. Data quality checks PASS.
4. CETAS validation PASS.
5. Cost-control screenshot showing Serverless-only approach.

Do not overload the README with every screenshot.

Use this evidence index for the full evidence trail.

## 6. Evidence Notes from Implementation

Important implementation findings worth preserving in documentation:

### External Table DDL Nullability

Synapse Serverless external tables did not accept `NOT NULL` column declarations. The final external table DDL uses nullable column definitions, while logical nullability remains documented in the source data model and validated through SQL checks.

### CETAS Column Alignment

The CETAS output was aligned to the real reporting view schema:

```text
order_date
order_count
total_quantity
total_revenue
```

Earlier draft references to non-existent columns such as `gross_revenue` or `completed_revenue` were corrected.

### Metadata and External Data Query Separation

The CETAS validation script separates metadata checks against system views from row-count and business validation checks against external data. This avoids unsupported query patterns that mix system catalog views with distributed external data processing.

## 7. Current Evidence Status

Current implementation status:

```text
ADLS Parquet files uploaded: Completed
Synapse workspace created: Completed
Serverless SQL first query: Completed
Database created: Completed
External data source created: Completed
External file format created: Completed
External tables created: Completed
Smoke test: PASS
Reporting views: PASS
Analytical queries: PASS
Data quality checks: PASS
CETAS output: PASS
CETAS validation: PASS
```

Evidence screenshots still need to be selected, cropped/redacted, named, and committed.
