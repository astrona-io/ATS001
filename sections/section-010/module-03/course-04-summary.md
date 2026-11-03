---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green
  or canary)
---
# Summary

A canary exposes a new version alongside known capacity. Shared selection can use endpoint counts to influence distribution, but connections, readiness and affinity prevent a universal request-percentage guarantee.

Promotion requires version-specific evidence about useful behavior. Withdrawal changes capacity or routing and still needs propagation and compatibility considerations. Release cleanup and rollback readiness require deliberate decisions.

Canary exposure depends on eligible endpoints and client connection behavior. A reliable promotion decision connects version identity to error rate, latency and meaningful operation results over a stated observation period.

The size of a Service-based canary comes from replica counts, and kubectl scale changes it without a rollout. Promotion updates the stable Deployment first and removes the canary second. Withdrawal scales the canary to zero or narrows the Service selector.

<!-- astrona:playground:destroy -->
