# Future Improvements

**Project:** `azure-synapse-serverless-serving-layer`  
**Document:** Future Improvements  
**Status:** Phase 6 — Documentation and Evidence Package  
**Last updated:** 2026-07-17

## 1. Purpose

This document lists future improvements that could strengthen the project beyond the MVP.

These items are intentionally out of scope for the first implementation but are useful to discuss in interviews and roadmap planning.

## 2. Add Partitioned Data Layout

A future version could partition curated Parquet files by:

```text
order_year
order_month
order_date
```

Professional value:

- Better query pruning
- Lower data scanned
- More realistic analytical lake layout
- Stronger cost-control demonstration

## 3. Add OPENROWSET Exploration

The current project focuses on external tables.

A future enhancement or companion lab module can compare:

```text
OPENROWSET vs External Tables
```

Professional value:

- Explains ad hoc exploration vs reusable SQL object design.
- Strengthens Synapse Serverless interview defense.

## 4. Add Power BI Consumption Layer

A future improvement could connect Power BI to the Synapse Serverless SQL endpoint.

Professional value:

- Demonstrates downstream BI consumption.
- Connects serving-layer design to business reporting.
- Shows how curated SQL views can support dashboards.

## 5. Add Infrastructure as Code

A future version could provision resources using Bicep or Terraform.

Professional value:

- Repeatable deployments
- Environment consistency
- DevOps readiness
- Stronger production-aligned story

## 6. Add CI/CD

A future version could deploy SQL scripts and documentation through GitHub Actions or Azure DevOps.

Professional value:

- Version-controlled release process
- Repeatable promotion between environments
- Stronger production-readiness signal

## 7. Add Security Hardening

Potential security enhancements:

- Private endpoints
- Managed virtual network
- Data exfiltration protection
- More granular RBAC
- Separate reader/writer identities
- Key Vault for secrets where relevant

Professional value:

- Enterprise-grade security discussion
- Better alignment with production Azure environments

## 8. Add Purview / Governance Integration

A future governance project could catalog the datasets and document lineage.

Professional value:

- Data discovery
- Metadata management
- Business glossary
- Ownership and stewardship
- Lineage visibility

## 9. Add Larger Dataset and Performance Testing

A future version could increase dataset size to test query behavior more realistically.

Professional value:

- Cost and performance analysis
- File-size strategy
- Scan-volume comparison
- Practical tuning discussion

## 10. Add Delta Lake Consumption Scenario

A future extension could query Databricks-produced Gold outputs or Delta-compatible exports.

Professional value:

- Connects Databricks Lakehouse project with Synapse serving layer.
- Demonstrates multi-service Azure architecture.

## 11. Add Data Contract Documentation

A future version could formalize each external table as a data contract.

Potential fields:

- Dataset owner
- Grain
- Schema
- Nullable rules
- Valid status values
- Refresh frequency
- SLA expectations
- Known caveats

Professional value:

- Better operational clarity
- Stronger data product thinking

## 12. Add Companion Learning Lab

A separate private learning lab will reinforce Synapse Serverless skills.

Planned repository:

```text
azure-synapse-learning-lab
```

Planned learning themes:

- Serverless SQL basics
- OPENROWSET vs external tables
- Schema-on-read behavior
- Reporting views
- Data quality validation
- CETAS outputs
- Cost-aware querying
- Troubleshooting playbook

Professional value:

- Converts project implementation into repeatable technical fluency.
- Preserves a clean boundary between public portfolio and private practice.

## 13. Recommended Next Improvement

The most valuable next improvement after MVP closeout is:

```text
Build the companion azure-synapse-learning-lab repository.
```

Reason:

The public project proves implementation. The lab builds mastery.
