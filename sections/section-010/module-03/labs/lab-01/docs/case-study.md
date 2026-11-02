---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green
  or canary)
---
# Starting Environment

The application and client fixtures are healthy. Complete the required change without replacing unrelated resources.

Keep three stable version-one replicas and one version-two canary replica. Select both groups with `app: probe, track: shared` through the original Service. Each Deployment must retain its own ownership selector. All four backends must appear ready in EndpointSlices. Do not claim an exact traffic percentage from this replica ratio.
