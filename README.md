# Application Deployment (ATS001)

Certified Kubernetes Application Developer (CKAD): Application Deployment, worth 20% of the curriculum and part of ATP006.

Each section has an introduction. Each module combines detailed concept readings, an ungraded isolated playground, guided practical work and a closing summary. YAML knowledge checks remain separately indexed. Technical content stays draft for review. New graded labs are not included.

## Course Outline

| Section / module | Module | Concept and practical readings |
| --- | --- | --- |
| 010 / 02 | A Prepared Blue-Green Switch | Switching Service Traffic Between Two Versions; Switch A Service Between Ready Versions |
| 010 / 03 | Canary Exposure And Promotion | Reasoning About Canary Traffic With Ordinary Services; Observe Canary Backends Without Assuming Exact Percentages |
| 020 / 03 | Rolling Updates And Availability | Rolling Updates And Health Gates; Calculating Rollout Capacity And Diagnosing Progress; Perform And Inspect A Rolling Template Update |
| 020 / 04 | Release Diagnosis And Template History | Intended Versions And Observed Progress; Reproduce, Correct And Verify; Diagnose A Failed Image Update And Repair The Template |
| 030 / 02 | Reusable Kustomize Composition | Composing Resources With Kustomize; Render And Apply A Self-Contained Kustomize Base |
| 030 / 03 | Focused Patches For Environment Changes | Targeted Patches And Environment Differences; Patch One Environment Without Editing Its Base |
| 040 / 03 | Existing Charts And Effective Values | Charts, Values And The Rendered Application; Install An Existing Chart And Inspect Effective Values |
| 040 / 04 | Release Operations And Recovery Limits | Release History, Upgrades And Controlled Recovery; Upgrade A Release And Inspect Controlled Recovery |

## Author Review

See [curriculum coverage](CURRICULUM.md), [primary sources](SOURCES.md), [assessment contracts](ASSESSMENTS.md) and [contribution guidance](CONTRIBUTING.md). Each playground has its own config, bootstrap, guide and author smoke script. Static checks passed; live execution remains pending because the authoring session cannot access the container engine. Retain that limitation until real runtime evidence is recorded.
