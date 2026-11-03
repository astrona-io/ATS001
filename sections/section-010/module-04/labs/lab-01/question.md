---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green or canary)
---
# Create A Weighted Canary Ingress

Add a canary Ingress that sends a fixed share of requests for the existing host to the canary Service.

## Objective

Add a canary Ingress that sends a fixed share of requests for the existing host to the canary Service.

## Starting state

The `probe` Service selects the stable Pods. The `probe-canary` Deployment and Service run version two. Ingress `probe` already sends host `probe.starfleet.test` to Service `probe` on port 80. The environment has no Ingress controller: the grader checks the Ingress objects, not live routing through them.

Use a host shell with this lab's private kubeconfig. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool. This environment is separate from the ungraded playground.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-lab-010-04-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-lab-010-04-01" || exit 1
```

Keep this connection selected throughout the task. Every script supplied by the lab refuses a different context.

## Required result

Create Ingress `probe-canary` in `starfleet` with `ingressClassName: nginx`, the annotation `nginx.ingress.kubernetes.io/canary: "true"` and the annotation `nginx.ingress.kubernetes.io/canary-weight: "20"`. It must use host `probe.starfleet.test`, path `/` with path type `Prefix`, and backend Service `probe-canary` on port 80. Do not change Ingress `probe`.

## Verify The Result

The grader checks the stated resource fields and live evidence. Wait for controllers to finish before submitting. Inspect the actual results with kubectl instead of assuming they match this task text.
