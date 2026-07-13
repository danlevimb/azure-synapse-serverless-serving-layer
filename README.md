# azure-synapse-serverless-serving-layer# Azure Synapse Serverless Serving Layer

## Overview

This project demonstrates a SQL serving layer over curated data stored in Azure Data Lake Storage Gen2 using Azure Synapse Serverless SQL.

The goal is to expose curated Parquet datasets through external tables, reporting views, and analytical SQL queries so downstream users can consume Data Lake assets through a familiar SQL interface.

This project is part of an Azure Data Engineering portfolio focused on practical, recruiter-facing, and technically defensible cloud data engineering patterns.

## Professional Narrative

I built a SQL serving layer over Azure Data Lake Storage Gen2 using Azure Synapse Serverless SQL. The project exposes curated Parquet datasets through external tables and analytical views, demonstrates cost-aware querying patterns, and documents a structured data serving model for downstream analytics and BI consumption.

## Project Objective

Build a portfolio-ready Synapse Serverless SQL project that demonstrates:

* SQL access over files stored in ADLS Gen2
* External data source configuration
* External file format definition
* External tables over curated Parquet datasets
* Analytical SQL views
* SQL query examples for business reporting
* Optional CETAS output back to ADLS Gen2
* Cost-aware querying practices
* Evidence-backed documentation

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
Analytical views
        ↓
SQL query examples
        ↓
Optional CETAS curated output
```

## Business Scenario

A retail business stores curated sales, customer, product, order, and order item datasets in Azure Data Lake Storage Gen2 as Parquet files.

Analytical users need SQL access to answer questions such as:

* What are total sales by date?
* Which customers generate the most revenue?
* Which products sell the most?
* Which cities generate the highest order value?
* What is the distribution of order statuses?
* Are there basic data quality issues visible from the serving layer?

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

## Planned Documentation

| Document                          | Purpose                                                                             |
| --------------------------------- | ----------------------------------------------------------------------------------- |
| `docs/architecture_and_scope.md`  | Defines project scope, target architecture, MVP boundaries, and implementation plan |
| `docs/data_serving_strategy.md`   | Explains how curated lake data is exposed for analytical consumption                |
| `docs/source_data_model.md`       | Documents the retail sample data model                                              |
| `docs/adls_folder_structure.md`   | Documents the ADLS Gen2 layout                                                      |
| `docs/synapse_object_model.md`    | Documents Synapse database, schemas, external tables, and views                     |
| `docs/query_examples.md`          | Documents analytical SQL query examples                                             |
| `docs/cost_controls.md`           | Documents serverless SQL cost-aware querying practices                              |
| `docs/known_limitations.md`       | Documents MVP limitations                                                           |
| `docs/future_improvements.md`     | Documents possible production enhancements                                          |
| `docs/certification_alignment.md` | Maps project concepts to Microsoft data engineering certification-related skills    |
| `docs/evidence_index.md`          | Indexes execution evidence                                                          |

## Planned SQL Artifacts

| Script                                   | Purpose                                           |
| ---------------------------------------- | ------------------------------------------------- |
| `sql/00_create_database.sql`             | Create project database and schemas               |
| `sql/01_create_external_data_source.sql` | Create external data source to ADLS Gen2          |
| `sql/02_create_external_file_format.sql` | Create Parquet external file format               |
| `sql/03_create_external_tables.sql`      | Create external tables over curated datasets      |
| `sql/04_create_reporting_views.sql`      | Create reporting views for analytical consumption |
| `sql/05_analytical_queries.sql`          | Provide business query examples                   |
| `sql/06_data_quality_queries.sql`        | Provide validation and quality check queries      |
| `sql/07_cetas_output.sql`                | Create optional CETAS output                      |
| `sql/08_cleanup.sql`                     | Cleanup script for demo objects                   |

## MVP Scope

Included:

* Azure Data Lake Storage Gen2
* Azure Synapse Serverless SQL
* Parquet curated datasets
* External data source
* External file format
* External tables
* Reporting views
* Analytical SQL queries
* Optional CETAS output
* Evidence-backed documentation
* Cost-control documentation

Out of scope for the MVP:

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

## Current Status

```text
Phase 1 — Repository Foundation
```

## Next Steps

1. Create the base repository structure.
2. Define the source data model.
3. Prepare controlled sample data.
4. Upload curated Parquet files to ADLS Gen2.
5. Create Synapse Serverless SQL database and external objects.
6. Build reporting views and analytical queries.
7. Capture evidence.
8. Complete documentation and final QA.
