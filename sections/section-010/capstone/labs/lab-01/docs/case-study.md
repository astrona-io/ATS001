---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green or canary)
---
# Starting Environment

Service `probe` selects Deployment `probe` (version v1, two replicas). Service `relay` selects every Pod labelled `app: relay`, which today means the three Pods of Deployment `relay-stable` (version v1). Both applications use the ConfigMap `probe-code` for their code.

For `probe`: create Deployment `probe-green` with two ready replicas, labels `app: probe` and `release: probe-green`, and `VERSION` set to `v2`, then change only the selector of Service `probe` to those two labels. Keep Deployment `probe`. For `relay`: create Deployment `relay-canary` with one ready replica, labels `app: relay` and `release: relay-canary`, and `VERSION` set to `v2`. Do not change Service `relay` or Deployment `relay-stable`. Use the same Pod template shape (image, command, readiness probe, volume) as the existing Deployments. The `shuttle` client must receive version two from `probe`, and `relay` must have four ready endpoints.
