# Evidence Index

**Project:** `azure-synapse-serverless-serving-layer`  
**Status:** Current public proof map

---

## 1. Purpose

This document maps the project's public claims to artifacts that are actually versioned in the repository.

The repository uses two evidence types:

1. **Implementation artifacts** — SQL, scripts, sample data, and documentation that prove what was built.
2. **Public-safe screenshots** — supplemental execution evidence where it was actually captured and committed.

The screenshot pack is intentionally described as **partial** because the repository does not contain the full screenshot checklist originally planned during Phase 6.

## 2. Implementation evidence

| Claim | Public artifact |
|---|---|
| Controlled retail data exists | `scripts/generate_sample_data.py` + `sample_data/generated/` |
| Curated Parquet assets are versioned | `sample_data/generated/curated/retail/` |
| Synapse can be granted lake read access through Managed Identity | `scripts/grant_synapse_storage_reader.ps1` |
| External data source is defined | `sql/01_create_external_data_source.sql` |
| Parquet external file format is defined | `sql/02_create_external_file_format.sql` |
| Four external tables are defined | `sql/03_create_external_tables.sql` |
| External-table row-count smoke test exists | `sql/04_smoke_test_external_tables.sql` |
| Reporting views are defined | `sql/05_create_reporting_views.sql` |
| Business-facing analytical queries are versioned | `sql/06_analytical_queries.sql` |
| Data-quality checks are versioned | `sql/07_data_quality_queries.sql` |
| CETAS serving output is defined | `sql/08_cetas_output.sql` |
| CETAS metadata and business totals are validated | `sql/09_validate_cetas_output.sql` |

## 3. Strongest implementation proof chain

```text
Curated Parquet files
        ↓
External data source / file format
        ↓
External tables
        ↓
Reporting views
        ↓
Analytical + data-quality queries
        ↓
CETAS serving output
        ↓
CETAS validation
```

This sequence is fully represented by versioned repository artifacts.

## 4. Public screenshot evidence

The repository currently contains this public-safe screenshot:

| File | What it proves |
|---|---|
| [`01_adls_parquet_upload_success.png`](../evidence/01_adls_structure/01_adls_parquet_upload_success.png) | Curated Parquet data was uploaded to the ADLS project structure |

Additional execution screenshots were part of the original evidence plan but are **not currently committed**. They must not be described as present.

## 5. Evidence claim boundary

Safe public claims:

- Synapse Serverless SQL object model is implemented in SQL scripts.
- External tables over Parquet are defined.
- Reporting views are implemented.
- Data-quality queries are implemented.
- CETAS output and validation logic are implemented.
- Controlled sample data and curated Parquet files are versioned.
- A Managed Identity / RBAC helper script is included.
- One ADLS upload screenshot is publicly versioned.

Do not claim that the public repository currently contains a complete portal-screenshot trail for every execution milestone.

## 6. Public-safety rules

Do not publish:

- Subscription IDs
- Tenant IDs
- Object IDs / Principal IDs
- personal email addresses
- storage account keys
- SAS tokens
- connection strings
- passwords
- private machine names
- sensitive portal URLs

## 7. Future evidence enhancement

A future evidence refresh could add a small, high-value screenshot pack for:

1. external tables smoke test;
2. reporting view result;
3. data-quality PASS result;
4. CETAS validation PASS;
5. Serverless-only cost-control confirmation.

Those screenshots are optional future portfolio enhancements and are not required to understand the implemented SQL artifacts.
