---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Switch To Recreate And Scale With One Rollout

Change Deployment `relay` to the Recreate strategy, scale it to three replicas and update its version in one rollout.

## Objective

Change Deployment `relay` to the Recreate strategy, scale it to three replicas and update its version in one rollout.

## Starting state

Deployment `relay` runs two replicas of version v1 with an explicit `RollingUpdate` strategy (`maxSurge: 1`, `maxUnavailable: 1`). Service `relay` selects its Pods.

Use a host shell with this lab's private kubeconfig. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool. This environment is separate from the ungraded playground.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-lab-020-06-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-lab-020-06-01" || exit 1
```

Keep this connection selected throughout the task. Every script supplied by the lab refuses a different context.

## Required result

Change Deployment `relay` to strategy type `Recreate`, three replicas and `VERSION` set to `v2`. The Deployment must not keep any `rollingUpdate` settings and must not stay paused. Wait until three replicas are updated, ready and available. The `shuttle` client must receive version v2 from Service `relay`.

## Verify The Result

The grader checks the stated resource fields and live evidence. Wait for controllers to finish before submitting. Inspect the actual results with kubectl instead of assuming they match this task text.
