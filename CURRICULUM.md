# Curriculum Coverage

Exam: Certified Kubernetes Application Developer (CKAD). Domain: Application Deployment (20%).

The [official objectives](https://training.linuxfoundation.org/certification/certified-kubernetes-application-developer-ckad/) were verified on 2026-10-11. Teaching structure is original; it does not add official exam requirements.

| Section | Official objective | Modules |
| --- | --- | --- |
| 010 | Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green or canary) | 2 |
| 020 | Understand Deployments and how to perform rolling updates | 2 |
| 030 | Kustomize | 2 |
| 040 | Use the Helm package manager to deploy existing packages | 2 |

| Section / module | Module | Teaching lessons |
| --- | --- | --- |
| 010 / 02 | A Prepared Blue-Green Switch | Switching Service Traffic Between Two Versions |
| 010 / 03 | Canary Exposure And Promotion | Reasoning About Canary Traffic With Ordinary Services |
| 020 / 03 | Rolling Updates And Availability | Rolling Updates And Health Gates; Calculating Rollout Capacity And Diagnosing Progress |
| 020 / 04 | Release Diagnosis And Template History | Intended Versions And Observed Progress; Reproduce, Correct And Verify |
| 030 / 02 | Reusable Kustomize Composition | Composing Resources With Kustomize |
| 030 / 03 | Focused Patches For Environment Changes | Targeted Patches And Environment Differences |
| 040 / 03 | Existing Charts And Effective Values | Charts, Values And The Rendered Application |
| 040 / 04 | Release Operations And Recovery Limits | Release History, Upgrades And Controlled Recovery |

The module goals and adaptation sources are recorded in AUTHORING.yaml. Every official objective is covered. Each section starts with an introduction, and each module ends with a summary. YAML banks follow the relevant summary and remain separate from the Markdown manifest.

This is a reading-only draft. No new labs, playgrounds, command output or runtime verification are included. ATP006 publication remains draft.

## Hands-On Expansion

Playgrounds and guided practical readings were added on 2026-10-12. Every existing module retains its concept readings and gains one practical reading before its renumbered summary. YAML bank placement follows the new summary path. Official weights, objective IDs and ATP006 links are unchanged. Runtime verification is pending; static checks do not establish successful cluster execution.

## Graded Lab Expansion

Every active module includes a draft independent graded lab. This course has 8 active graded labs, registered after the readings they practise. Each has its own cluster, task, solution, context guards, reference repair and behavior grader. Static and offline checks pass. Live verification remains pending because the authoring session cannot access the Podman socket. The installed CLI's configuration validator is separately blocked by its local-state maintenance lock.

| Module | Labs in teaching order |
| --- | --- |
| 010/02 | Switch A Service To A Ready Deployment |
| 010/03 | Configure Stable And Canary Backends |
| 020/03 | Perform A Rolling Template Update |
| 020/04 | Recover A Failed Deployment Update |
| 030/02 | Apply A Kustomize Base |
| 030/03 | Patch A Preview With Kustomize |
| 040/03 | Install A Chart With Explicit Values |
| 040/04 | Upgrade An Existing Helm Release |
