---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green
  or canary)
---
# Switch A Service To A Ready Deployment

Move the original Service to a ready version-two Deployment while preserving the previous version. Use the isolated `starfleet` environment to verify the result.

## Objective

Move the original Service to a ready version-two Deployment while preserving the previous version.

## Starting state

The application and client fixtures are healthy. Complete the required change without replacing unrelated resources.

Use a host shell with this lab's private kubeconfig. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool. This environment is separate from the ungraded playground.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-lab-010-02-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-lab-010-02-01" || exit 1
```

Keep this connection selected throughout the task. Every script supplied by the lab refuses a different context.


## Required result

Create Deployment `probe-green` with two replicas running version `v2`, label `release: green` and the existing application command. Change only the `probe` Service selector to `app: probe, release: green`. Keep TCP port 80 and target port `http`. Preserve the original `probe` Deployment. The original client must receive version two.

## Verify The Result

The grader checks the stated resource fields and live evidence. Wait for controller convergence before submitting. Inspect actual results rather than relying on a sample transcript.
