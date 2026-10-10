---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green
  or canary)
---
# Summary

A canary exposes a new version alongside known capacity. Shared selection can use endpoint counts to influence distribution, but connections, readiness and affinity prevent a universal request-percentage guarantee.

Promotion requires version-specific evidence about useful behavior. Withdrawal changes capacity or routing and still needs propagation and compatibility considerations. Release cleanup and rollback readiness require deliberate decisions.
