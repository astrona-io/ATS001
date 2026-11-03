---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Deployment Rollout Repair And Strategy Capstone

Roll `bridge` back to its last working revision and change `scanner` to a Recreate rollout at three replicas.

## Objective

Roll `bridge` back to its last working revision and change `scanner` to a Recreate rollout at three replicas.

## Starting state

Deployment `bridge` has three revisions. Revision one (v1) and revision two (`VERSION` v2) work. Revision three uses an image tag that does not exist, so its new Pod cannot start. Deployment `scanner` runs two replicas of v1 with an explicit `RollingUpdate` strategy.

Use a host shell with this lab's private kubeconfig. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool. This environment is separate from the ungraded playground.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-capstone-020)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-capstone-020" || exit 1
```

Keep this connection selected throughout the task. Every script supplied by the lab refuses a different context.

## Required result

Return `bridge` to its last working revision (version v2 with the image `docker.io/library/python:3.13-alpine`) and wait for two available replicas. Change Deployment `scanner` to strategy type `Recreate` with no `rollingUpdate` settings, three replicas and `VERSION` set to `v3`, and wait for three available replicas. The `shuttle` client must receive version v2 from Service `bridge` and version v3 from Service `scanner`.

## Verify The Result

The grader checks the stated resource fields and live evidence. Wait for controllers to finish before submitting. Inspect the actual results with kubectl instead of assuming they match this task text.
