---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green or canary)
---
# Blue-Green And Canary Release Capstone

Release two applications with two strategies: switch `probe` to a prepared green version and add a one-replica canary to `relay`.

## Objective

Release two applications with two strategies: switch `probe` to a prepared green version and add a one-replica canary to `relay`.

## Starting state

Service `probe` selects Deployment `probe` (version v1, two replicas). Service `relay` selects every Pod labelled `app: relay`, which today means the three Pods of Deployment `relay-stable` (version v1). Both applications use the ConfigMap `probe-code` for their code.

Use a host shell with this lab's private kubeconfig. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool. This environment is separate from the ungraded playground.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-capstone-010)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-capstone-010" || exit 1
```

Keep this connection selected throughout the task. Every script supplied by the lab refuses a different context.

## Required result

For `probe`: create Deployment `probe-green` with two ready replicas, labels `app: probe` and `release: probe-green`, and `VERSION` set to `v2`, then change only the selector of Service `probe` to those two labels. Keep Deployment `probe`. For `relay`: create Deployment `relay-canary` with one ready replica, labels `app: relay` and `release: relay-canary`, and `VERSION` set to `v2`. Do not change Service `relay` or Deployment `relay-stable`. Use the same Pod template shape (image, command, readiness probe, volume) as the existing Deployments. The `shuttle` client must receive version two from `probe`, and `relay` must have four ready endpoints.

## Verify The Result

The grader checks the stated resource fields and live evidence. Wait for controllers to finish before submitting. Inspect the actual results with kubectl instead of assuming they match this task text.
