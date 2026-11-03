---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green
  or canary)
---
# Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green or canary)

This section covers blue-green and canary releases built from ordinary Kubernetes objects. You will study A Prepared Blue-Green Switch, Canary Exposure And Promotion and Canary Routing With Ingress. The lessons explain the responsible components, configuration relationships and failure cases relevant to application development. A capstone lab closes the section, and a knowledge check follows it.

You will separate version capacity from traffic exposure. Blue-green keeps a replacement ready before a selector switch; a basic canary shares eligible backends while its observed request share depends on connections and readiness. An Ingress canary sets a weight with controller annotations. The central question is which version actually serves the intended operation.

## Learning Outcomes

- Explain Service selection across two versions.
- Verify readiness, capacity and backend ports.
- Diagnose a switch that fails because of the selector, readiness or target port.
- Distinguish a traffic switch from a data migration.
- Evaluate the conditions for safe traffic rollback.
- Explain shared Service selection for stable and canary Pods.
- Size, promote and withdraw a canary with replica counts.
- Estimate exposure from ready endpoints with stated limits.
- Configure a weighted canary Ingress and state what depends on the controller.
- Distinguish withdrawal from full release promotion.

Each module pairs its concept readings with a guided practical sequence in an isolated playground. Finish the practice and closing summary before moving on.
