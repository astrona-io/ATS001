# Application Deployment (ATS001)

Certified Kubernetes Application Developer (CKAD): Application Deployment, worth 20% of the curriculum and part of ATP006.

Each section has an introduction. Each module combines detailed concept readings, an ungraded isolated playground, guided practical work and a closing summary. YAML knowledge checks remain separately indexed. Technical content stays draft for review. Every taught module includes a draft independent graded lab. Earlier modules that the taught modules replace are kept in `legacy/` and are not part of the course.

## Course Outline

| Section / module | Module | Concept and practical readings |
| --- | --- | --- |
| 010 / 02 | A Prepared Blue-Green Switch | Switching Service Traffic Between Two Versions; Switch A Service Between Ready Versions |
| 010 / 03 | Canary Exposure And Promotion | Reasoning About Canary Traffic With Ordinary Services; Observe Canary Backends Without Assuming Exact Percentages |
| 010 / 04 | Canary Routing With Ingress | Routing A Host To Two Services With Ingress; Canary Annotations And Their Limits; Create A Weighted Canary Ingress; Practise Canary Ingress Objects |
| 020 / 03 | Rolling Updates And Availability | Rolling Updates And Health Gates; Calculating Rollout Capacity And Diagnosing Progress; Perform And Inspect A Rolling Template Update |
| 020 / 04 | Release Diagnosis And Template History | Intended Versions And Observed Progress; Reproduce, Correct And Verify; Diagnose A Failed Image Update And Repair The Template |
| 020 / 05 | Revision History And Rollback | Recording And Reading Revision History; Rolling Back To A Chosen Revision; Roll Back To A Named Revision; Practise History And Rollback |
| 020 / 06 | Deployment Strategy, Scaling And Pause | Choosing A Deployment Strategy; Pausing A Rollout To Batch Changes; Switch To Recreate And Scale With One Rollout; Practise Strategy, Scaling And Pause |
| 030 / 02 | Reusable Kustomize Composition | Composing Resources With Kustomize; Render And Apply A Self-Contained Kustomize Base |
| 030 / 03 | Focused Patches For Environment Changes | Targeted Patches And Environment Differences; Patch One Environment Without Editing Its Base |
| 030 / 04 | Generating ConfigMaps And Secrets With Kustomize | Generating ConfigMaps And Content Hashes; Secrets, Behavior And Generator Options; Generate Settings And Roll Them Out |
| 040 / 03 | Existing Charts And Effective Values | Charts, Values And The Rendered Application; Install An Existing Chart And Inspect Effective Values |
| 040 / 04 | Release Operations And Recovery Limits | Release History, Upgrades And Controlled Recovery; Upgrade A Release And Inspect Controlled Recovery |
| 040 / 05 | Finding, Packaging And Installing Charts | Chart Repositories And Versions; Archives, Dependencies And Pulling Charts; Serve A Local Repository And Install From It |

## Author Review

See [curriculum coverage](CURRICULUM.md), [primary sources](SOURCES.md), [assessment contracts](ASSESSMENTS.md) and [contribution guidance](CONTRIBUTING.md). Each playground has its own config, bootstrap, guide and author smoke script. Static checks passed; live execution remains pending because the authoring session cannot access the container engine. Retain that limitation until real runtime evidence is recorded.

## Graded Lab Expansion

Every taught module includes a draft independent graded lab, and each section ends with a capstone lab. This course has 13 taught modules and 17 draft graded labs (13 module labs and 4 section capstones), registered after the readings they practise. Each has its own cluster, task, solution, context guards, reference repair and behavior grader. Static and offline checks pass. Live verification remains pending because the authoring session cannot access the Podman socket. The installed CLI's configuration validator is separately blocked by its local-state maintenance lock.

| Module | Labs in teaching order |
| --- | --- |
| 010/02 | Switch A Service To A Ready Deployment |
| 010/03 | Configure Stable And Canary Backends |
| 010/04 | Create A Weighted Canary Ingress |
| 010 capstone | Blue-Green And Canary Release Capstone |
| 020/03 | Perform A Rolling Template Update |
| 020/04 | Recover A Failed Deployment Update |
| 020/05 | Roll Back To A Named Revision |
| 020/06 | Switch To Recreate And Scale With One Rollout |
| 020 capstone | Deployment Rollout Repair And Strategy Capstone |
| 030/02 | Apply A Kustomize Base |
| 030/03 | Patch A Preview With Kustomize |
| 030/04 | Generate A ConfigMap With Kustomize |
| 030 capstone | Kustomize Section Capstone: Production Overlay |
| 040/03 | Install A Chart With Explicit Values |
| 040/04 | Upgrade An Existing Helm Release |
| 040/05 | Package A Chart And Install It From The Archive |
| 040 capstone | Helm Section Capstone: Recover And Update A Release |
