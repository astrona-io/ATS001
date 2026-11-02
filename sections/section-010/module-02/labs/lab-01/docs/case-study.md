---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green
  or canary)
---
# Starting Environment

The application and client fixtures are healthy. Complete the required change without replacing unrelated resources.

Create Deployment `probe-green` with two replicas running version `v2`, label `release: green` and the existing application command. Change only the `probe` Service selector to `app: probe, release: green`. Keep TCP port 80 and target port `http`. Preserve the original `probe` Deployment. The original client must receive version two.
