# Cost Controls

**Project:** `azure-synapse-serverless-serving-layer`  
**Document:** Cost Controls  
**Status:** Phase 6 — Documentation and Evidence Package  
**Last updated:** 2026-07-16

## 1. Purpose

This document explains the cost-control strategy for the `azure-synapse-serverless-serving-layer` project.

The project is intentionally designed to demonstrate a SQL serving layer over ADLS Gen2 while avoiding unnecessary provisioned compute and expensive always-on services.

## 2. Selected Compute Model

The MVP uses:

```text
Azure Synapse Serverless SQL
```

The MVP does not use:

```text
Dedicated SQL Pool
Apache Spark Pool
Data Explorer Pool
```

This keeps the project focused on SQL-based analytical access over data lake files without provisioning dedicated compute.

## 3. Cost-Aware Architecture

The architecture is cost-aware because it uses:

- Small controlled sample datasets.
- Parquet as the primary analytical file format.
- Serverless SQL instead of dedicated SQL compute.
- Query examples designed for limited scans.
- No always-on compute pools.
- No production monitoring stack in the MVP.
- No streaming services in the MVP.

## 4. Serverless SQL Cost Behavior

Synapse Serverless SQL charges based on data processed by queries.

This means project cost is influenced by:

- File size.
- Number of queries executed.
- Number of columns read.
- File format.
- Query design.
- Repeated scans over the same data.

## 5. Dataset Size Strategy

The MVP uses small synthetic retail datasets.

Recommended approximate row counts:

| Dataset | Target Row Count |
|---|---:|
| `customers` | 10 |
| `products` | 10 |
| `orders` | 24 |
| `order_items` | 43 |

This is enough to demonstrate analytical behavior without creating unnecessary scan volume.

## 6. File Format Strategy

The curated data is stored as Parquet.

Parquet is appropriate because:

- It is columnar.
- It supports analytical query patterns.
- It avoids scanning unnecessary columns when queries are selective.
- It is a common format for curated data lake assets.

## 7. Query Design Rules

The project follows these query design principles:

| Rule | Reason |
|---|---|
| Prefer named reporting views | Keeps consumption layer clear |
| Avoid unnecessary `SELECT *` in final examples | Reduces scanned columns |
| Select only columns needed for the business question | Reduces processed data |
| Use small validation queries | Keeps smoke tests cheap |
| Use Parquet instead of CSV for serving layer | Improves analytical scan efficiency |
| Keep CETAS outputs small | Avoids unnecessary write and scan cost |

## 8. Resource Scope Control

The project intentionally avoids creating:

- Dedicated SQL Pools.
- Spark Pools.
- Data Explorer Pools.
- Production monitoring resources.
- Private endpoint architecture.
- Purview governance resources.
- Power BI capacity.

These may be valid future improvements, but they are not required to prove the MVP serving-layer capability.

## 9. CETAS Cost Control

The CETAS output writes a small materialized analytical result to ADLS Gen2.

To control cost and avoid operational confusion:

- Use a small reporting view as the source.
- Write only the columns needed by the output.
- Use a clear run folder such as `run_id=manual_001/`.
- Avoid repeatedly recreating output folders unless needed.
- Clean up test outputs when rerunning is necessary.

## 10. Evidence Guidelines

Cost evidence should show:

- No Dedicated SQL Pool created.
- No Spark Pool created.
- Serverless SQL was used through the `Built-in` endpoint.
- Query scripts use Parquet external tables and targeted reporting views.
- Documentation explains that cost depends on data processed.

Screenshots should avoid exposing sensitive IDs, account details, emails, or subscription information.

## 11. Cleanup Considerations

After project evidence is captured, consider whether to keep or delete:

| Resource | Recommendation |
|---|---|
| Synapse Workspace | Keep temporarily if continuing documentation or demos |
| ADLS Gen2 account | Keep while evidence and scripts are being finalized |
| Dedicated SQL Pool | Should not exist for this MVP |
| Spark Pool | Should not exist for this MVP |
| CETAS output folders | Keep if used as evidence; otherwise clean test reruns |

## 12. MVP Cost Boundary

The MVP cost boundary is:

```text
Use only the resources needed to prove Synapse Serverless SQL serving over ADLS Gen2.
```

Anything beyond that should be documented as future improvement rather than implemented in the MVP.

## 13. Professional Value

This cost-control strategy shows that the project was designed with operational discipline.

The project demonstrates not only that the serving layer works, but also that the implementation avoids unnecessary provisioned compute and keeps Azure spending aligned with the project objective.
