---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green
  or canary)
---
# Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green or canary)

This section covers use Kubernetes primitives to implement common deployment strategies (e.g. blue/green or canary). You will study A Prepared Blue-Green Switch, Canary Exposure And Promotion. The lessons explain the responsible components, configuration relationships and failure cases relevant to application development.

Each module begins with its goals and ends with a summary. Reusable YAML knowledge checks follow the section summary and are registered separately for future presentation.

## Learning Outcomes

- Explain Service selection across two versions.
- Verify readiness, capacity and backend ports.
- Distinguish a traffic switch from a data migration.
- Evaluate the conditions for safe traffic rollback.
- Explain shared Service selection for stable and canary Pods.
- Estimate exposure from ready endpoints with stated limits.
- Choose version-specific promotion evidence.
- Distinguish withdrawal from full release promotion.
