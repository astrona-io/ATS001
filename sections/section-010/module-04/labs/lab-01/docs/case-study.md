---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green or canary)
---
# Starting Environment

The `probe` Service selects the stable Pods. The `probe-canary` Deployment and Service run version two. Ingress `probe` already sends host `probe.starfleet.test` to Service `probe` on port 80. The environment has no Ingress controller: the grader checks the Ingress objects, not live routing through them.

Create Ingress `probe-canary` in `starfleet` with `ingressClassName: nginx`, the annotation `nginx.ingress.kubernetes.io/canary: "true"` and the annotation `nginx.ingress.kubernetes.io/canary-weight: "20"`. It must use host `probe.starfleet.test`, path `/` with path type `Prefix`, and backend Service `probe-canary` on port 80. Do not change Ingress `probe`.
