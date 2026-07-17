# Known Limitations

**Project:** `azure-synapse-serverless-serving-layer`  
**Document:** Known Limitations  
**Status:** Phase 6 — Documentation and Evidence Package  
**Last updated:** 2026-07-17

## 1. Purpose

This document describes the known limitations of the MVP implementation.

The goal is to keep the project honest, technically defensible, and clearly scoped.

## 2. MVP Scope Limitation

This project is a focused serving-layer MVP.

It demonstrates:

- ADLS Gen2 curated Parquet files
- Synapse Serverless SQL
- External data source
- External file format
- External tables
- Reporting views
- Analytical SQL queries
- Data quality queries
- CETAS output

It does not claim to be a full production data platform.

## 3. No Dedicated SQL Pool

The project does not use a Dedicated SQL Pool.

Reason:

- The objective is serverless SQL serving over lake files.
- The dataset is small.
- The MVP should remain cost-aware.
- Dedicated SQL Pool would add unnecessary provisioned compute cost and operational complexity.

## 4. No Spark Pool

The project does not use a Synapse Spark Pool.

Reason:

- Data generation happens locally through a Python script.
- The serving layer is implemented with Serverless SQL.
- Spark is not required to prove the MVP objective.

## 5. No Production Security Hardening

The MVP does not implement enterprise-grade security hardening such as:

- Private endpoints
- Managed virtual network configuration
- Data exfiltration protection
- Customer-managed keys
- Advanced firewall design
- Full RBAC model by persona

The project uses a practical MVP access pattern appropriate for portfolio demonstration.

## 6. No Full CI/CD

The project does not include full CI/CD deployment automation.

Reason:

- The MVP focuses on architecture, SQL objects, evidence, and documentation.
- CI/CD is better demonstrated in a future production-readiness project.

## 7. No Infrastructure as Code

The project does not include Bicep, Terraform, or ARM templates.

Reason:

- Azure resources were created through the Azure Portal for learning clarity.
- IaC remains a future enhancement.

## 8. Small Synthetic Dataset

The project uses small synthetic retail datasets.

Reason:

- The objective is to demonstrate a serving layer, not large-scale performance testing.
- Small datasets reduce cost and make validation easier.

Limitation:

- The project does not benchmark query performance at scale.

## 9. No Advanced Partitioning

The Parquet folders are not deeply partitioned by date, year, month, or region.

Reason:

- The dataset is intentionally small.
- The MVP emphasizes object model, SQL access, and query patterns.

Future versions may introduce partitioned layouts.

## 10. External Tables Do Not Enforce Constraints

Synapse Serverless external tables are schema-on-read objects over files.

The external table DDL does not enforce:

- Primary keys
- Foreign keys
- `NOT NULL` constraints
- Check constraints

Logical rules are documented in the data model and validated through SQL quality checks.

## 11. CETAS Re-run Behavior

CETAS does not overwrite an existing output folder.

If the output path already exists, the script may fail unless:

- The output folder is deleted first, or
- A new output path/run ID is used.

This behavior is documented in the CETAS script and validation notes.

## 12. No Power BI Dashboard

The MVP does not include a Power BI dashboard.

Reason:

- The focus is the SQL serving layer.
- BI visualization can be added later after the SQL interface is stable.

## 13. No Microsoft Purview Lineage

The project does not implement Purview lineage or cataloging.

Reason:

- Governance and lineage are planned as a later roadmap capability.

## 14. No Production Monitoring

The project does not include production monitoring, alerting, dashboards, or runbooks.

Reason:

- Synapse Serverless query evidence is sufficient for the MVP.
- Operational monitoring belongs to a production-readiness project.

## 15. Relationship to Learning Lab

The public project repository remains clean and portfolio-facing.

Hands-on repetition, attempts, mistakes, and troubleshooting drills will live in a separate private lab repository:

```text
azure-synapse-learning-lab
```

This separation avoids mixing portfolio artifacts with practice artifacts.
