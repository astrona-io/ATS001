---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green
  or canary)
---
# Configure Stable And Canary Backends

Expose stable and canary Deployments through one Service without assuming exact request percentages. Use the isolated `starfleet` environment to verify the result.

## Objective

Expose stable and canary Deployments through one Service without assuming exact request percentages.

## Starting state

The application and client fixtures are healthy. Complete the required change without replacing unrelated resources.

Use a host shell with this lab's private kubeconfig. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool. This environment is separate from the ungraded playground.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-lab-010-03-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-lab-010-03-01" || exit 1
```

Keep this connection selected throughout the task. Every script supplied by the lab refuses a different context.


## Required result

Keep three stable version-one replicas and one version-two canary replica. Select both groups with `app: probe, track: shared` through the original Service. Each Deployment must retain its own ownership selector. All four backends must appear ready in EndpointSlices. Do not claim an exact traffic percentage from this replica ratio.

## Verify The Result

The grader checks the stated resource fields and live evidence. Wait for controller convergence before submitting. Inspect actual results rather than relying on a sample transcript.
