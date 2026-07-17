# Certification Alignment

**Project:** `azure-synapse-serverless-serving-layer`  
**Document:** Certification Alignment  
**Status:** Phase 6 — Documentation and Evidence Package  
**Last updated:** 2026-07-17

## 1. Purpose

This document maps the project to Microsoft data engineering certification-related skills.

The project is primarily designed for portfolio value and practical Azure Data Engineering skill development.

Certification alignment is secondary and should be described as:

```text
Microsoft data engineering certification alignment
```

## 2. Current Certification Positioning

The broader roadmap uses DP-700 as the current primary Microsoft data engineering certification reference, while preserving DP-203 only as a legacy Azure Data Engineering skill reference.

This project is Azure Synapse-focused, so it is not a complete DP-700 preparation project by itself.

However, it reinforces transferable data engineering skills such as:

- Analytical serving layers
- Data lake access patterns
- SQL querying over lake files
- External tables
- Cost-aware querying
- Data validation
- Documentation and evidence

## 3. Skills Reinforced by This Project

| Skill Area | Project Reinforcement |
|---|---|
| Data lake consumption | Querying Parquet files stored in ADLS Gen2 |
| SQL-based serving | Exposing curated data through Synapse Serverless SQL |
| External object design | External data source, external file format, external tables |
| Analytical modeling | Reporting views over curated retail datasets |
| Data validation | SQL-based data quality checks |
| Cost awareness | Serverless query-cost discipline and avoiding provisioned pools |
| Output materialization | CETAS output back to ADLS Gen2 |
| Documentation discipline | Architecture, query examples, object model, evidence, limitations |

## 4. DP-700 / Fabric-Adjacent Relevance

Although this project uses Azure Synapse Serverless SQL instead of Microsoft Fabric, several concepts are transferable:

| Fabric/Data Engineering Concept | Project Connection |
|---|---|
| Lake-based analytics | ADLS Gen2 curated Parquet datasets |
| SQL consumption over lake data | Synapse Serverless SQL external tables and views |
| Data transformation outputs | CETAS materialized output |
| Monitoring and validation mindset | Smoke tests and data quality checks |
| Cost optimization | Query design and avoiding unnecessary scanned data |
| Documentation | Evidence-backed architecture and implementation notes |

## 5. DP-203 Legacy Skill Relevance

DP-203 is retired, but its historical Azure Data Engineering skill areas remain useful as a legacy reference.

This project reinforces legacy Azure skills such as:

- Designing analytical data stores
- Working with Azure Data Lake Storage Gen2
- Querying data in a lake using serverless SQL
- Creating external data sources and external tables
- Optimizing data access through file format and query design
- Validating data for analytical consumption

## 6. What This Project Does Not Cover

This project does not cover:

- Data ingestion orchestration
- Stream processing
- Dedicated SQL Pool design
- Spark transformation logic
- Full production security architecture
- CI/CD
- Infrastructure as Code
- Semantic modeling
- Power BI dashboard development

These are covered by other roadmap projects or future improvements.

## 7. Portfolio Positioning Statement

Recommended statement:

```text
This project is primarily a portfolio implementation demonstrating a SQL serving layer over ADLS Gen2 using Azure Synapse Serverless SQL. It secondarily reinforces Microsoft data engineering certification-related skills such as lake-based querying, external table design, analytical SQL serving, cost-aware query patterns, and data validation.
```

Avoid claiming:

```text
This project fully prepares for DP-700.
```

Better claim:

```text
This project supports certification-aligned learning by mapping practical Azure data serving patterns to Microsoft data engineering concepts.
```

## 8. Relationship to Companion Learning Lab

The companion learning lab will deepen hands-on fluency for interview defense.

Planned repository:

```text
azure-synapse-learning-lab
```

The lab will reinforce this project through guided exercises, SQL attempts, troubleshooting, and conceptual defense notes.
