---
draft: true
exam_objectives:
- Kustomize
---
# Patch A Preview With Kustomize

Use a targeted overlay to change capacity, labels and configuration. Use the isolated `starfleet` environment to verify the result.

## Objective

Use a targeted overlay to change capacity, labels and configuration.

## Starting state

The application and client fixtures are healthy. Complete the required change without replacing unrelated resources.

Use a host shell with this lab's private kubeconfig. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool. This environment is separate from the ungraded playground.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-lab-030-03-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-lab-030-03-01" || exit 1
```

Keep this connection selected throughout the task. Every script supplied by the lab refuses a different context.


## Required result

Keep a two-replica version-one base. Create a preview overlay that patches `probe` to one replica, template label `environment: preview` and `VERSION=preview`. Apply the overlay without editing the base. The client must receive the preview version. Grading checks the deployed preview; the file layout is checked by the author render test.

## Verify The Result

The grader checks the stated resource fields and live evidence. Wait for controller convergence before submitting. Inspect actual results rather than relying on a sample transcript.
