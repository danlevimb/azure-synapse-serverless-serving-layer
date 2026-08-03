# Project Closeout Checklist

**Project:** `azure-synapse-serverless-serving-layer`  
**Document:** Project Closeout Checklist  
**Status:** Final QA preparation

## 1. Purpose

This checklist defines the final steps required before the project can be considered portfolio-ready.

The project should not be closed only because the SQL scripts ran successfully.

It should be closed when the implementation, evidence, documentation, public safety review, and portfolio narrative are all complete.

## 2. Functional Completion

| Check | Status |
|---|---|
| ADLS Gen2 container created | Pending / Complete |
| Curated Parquet files uploaded | Pending / Complete |
| Synapse workspace created | Pending / Complete |
| Built-in Serverless SQL validated | Pending / Complete |
| Database `synapse_serving_demo` created | Pending / Complete |
| External data source created | Pending / Complete |
| External file format created | Pending / Complete |
| External tables created | Pending / Complete |
| Smoke test returned `PASS` | Pending / Complete |
| Reporting views created | Pending / Complete |
| Analytical queries executed successfully | Pending / Complete |
| Data quality checks returned `PASS` | Pending / Complete |
| CETAS output created | Pending / Complete |
| CETAS validation executed successfully | Pending / Complete |

## 3. Documentation Completion

| Document | Status |
|---|---|
| `README.md` | Pending / Complete |
| `docs/architecture_and_scope.md` | Pending / Complete |
| `docs/source_data_model.md` | Pending / Complete |
| `docs/adls_folder_structure.md` | Pending / Complete |
| `docs/data_serving_strategy.md` | Pending / Complete |
| `docs/synapse_object_model.md` | Pending / Complete |
| `docs/query_examples.md` | Pending / Complete |
| `docs/cost_controls.md` | Pending / Complete |
| `docs/evidence_index.md` | Pending / Complete |
| `docs/known_limitations.md` | Pending / Complete |
| `docs/future_improvements.md` | Pending / Complete |
| `docs/certification_alignment.md` | Pending / Complete |
| `docs/evidence_capture_guide.md` | Pending / Complete |

## 4. Evidence Completion

| Evidence Area | Status |
|---|---|
| Synapse workspace ready | Pending / Complete |
| ADLS curated data visible | Pending / Complete |
| Database created | Pending / Complete |
| External objects created | Pending / Complete |
| Smoke test PASS | Pending / Complete |
| Reporting views created | Pending / Complete |
| Analytical queries results | Pending / Complete |
| Data quality checks PASS | Pending / Complete |
| CETAS output and validation | Pending / Complete |
| Cost-control evidence | Pending / Complete |

## 5. Public Safety Review

Confirm the repository does not expose:

- SQL admin passwords.
- Storage account keys.
- SAS tokens.
- Connection strings.
- Subscription IDs.
- Tenant IDs.
- Object IDs.
- Private email addresses.
- Local machine names.
- Sensitive screenshots.

Recommended review commands:

```powershell
git status
Select-String -Path .\**\* -Pattern "password|secret|key|sas|token|subscription|tenant" -CaseSensitive:$false
```

Manual review is still required because screenshots cannot be safely scanned by text search.

## 6. Link and Rendering Review

Before closeout:

- Validate README renders correctly in GitHub.
- Validate all Markdown links work.
- Validate evidence links work.
- Validate screenshots open from GitHub.
- Validate SQL scripts are readable.
- Validate docs do not reference files that do not exist.

## 7. Portfolio Narrative Review

The final README should clearly communicate:

- What problem the project solves.
- What Azure services were used.
- Why Synapse Serverless SQL was selected.
- How external tables expose lake data.
- What reporting views provide.
- How data quality is validated.
- How CETAS writes serving output back to ADLS.
- What the MVP intentionally excludes.
- What future improvements would make it production-ready.

## 8. Companion Learning Lab Decision

Confirm companion lab repository:

```text
azure-synapse-learning-lab
```

The lab is separate from the public portfolio project and is used for:

- Guided exercises.
- Attempt scripts.
- Troubleshooting practice.
- Interview-defense notes.
- Repetition and technical fluency.

## 9. Roadmap Update Items

At final closeout, update the private roadmap repository with:

- Synapse project start decision.
- Functional MVP completion.
- Portfolio repo status.
- Companion dojo rule.
- Synapse learning lab repo creation/status.
- Updated project sequence.
- Updated master snapshot.

## 10. Closeout Criteria

The project is portfolio-ready when:

1. Functional MVP is complete.
2. SQL scripts are committed and ordered.
3. Documentation is complete.
4. Evidence package is public-safe.
5. README is polished.
6. Known limitations are honest.
7. Future improvements are clear.
8. Repo has no obvious secrets.
9. GitHub rendering and links are validated.
10. Private roadmap is updated.

