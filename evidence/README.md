# Evidence

This directory contains supplemental public-safe execution evidence for the Azure Synapse Serverless Serving Layer.

The repository's primary public proof is the versioned implementation itself:

- SQL object definitions;
- analytical and data-quality queries;
- CETAS materialization and validation scripts;
- sample data and curated Parquet files;
- helper automation.

The screenshot package is currently **partial**.

## Published screenshot

```text
01_adls_structure/
└── 01_adls_parquet_upload_success.png
```

This screenshot confirms the curated Parquet upload / lake structure.

See [../docs/evidence_index.md](../docs/evidence_index.md) for the complete claims-to-proof mapping.

## Public-safety rules

Do not commit screenshots exposing:

- subscription or tenant IDs;
- object / principal IDs;
- personal emails;
- keys or SAS tokens;
- connection strings;
- passwords;
- private machine names;
- sensitive portal URLs.
