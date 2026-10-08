# Visual Package

This directory contains the exact, version-controlled technical diagrams for the Azure Synapse Serverless Serving Layer.

## Assets

```text
diagrams/
├── 01_serverless_serving_architecture.mmd
└── 02_cetas_validation_flow.mmd
```

| Asset | Role |
|---|---|
| `01_serverless_serving_architecture.mmd` | End-to-end serving architecture from curated Parquet to SQL consumption and CETAS |
| `02_cetas_validation_flow.mmd` | CETAS materialization and validation sequence |

## Why Mermaid

The project intentionally uses Mermaid for its technical diagrams because:

- every node and claim is version-controlled;
- GitHub renders the diagrams directly in Markdown;
- architecture changes can be reviewed as text diffs;
- diagrams cannot silently introduce capabilities that the MVP did not implement.

## Scope discipline

The diagrams intentionally include only:

- ADLS Gen2 curated Parquet;
- Synapse Serverless SQL;
- external data source / file format;
- external tables;
- reporting views;
- analytical SQL;
- data-quality checks;
- CETAS output and validation.

They intentionally exclude:

- Dedicated SQL Pool;
- Spark Pool;
- Databricks;
- Azure Data Factory;
- Bicep / Terraform;
- private endpoints;
- Purview;
- production monitoring;
- real-time ingestion.

Those remain outside the implemented MVP.
