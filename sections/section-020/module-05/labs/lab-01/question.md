---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Roll Back To A Named Revision

Return Deployment `probe` to the version-one Pod template and record why in the change-cause annotation.

## Objective

Return Deployment `probe` to the version-one Pod template and record why in the change-cause annotation.

## Starting state

Deployment `probe` has gone through three revisions. Revision one runs version v1 and works. Revision two sets `VERSION` to v2 and works. Revision three points at an image tag that does not exist, so its new Pod cannot start. The two version-two Pods still serve requests.

Use a host shell with this lab's private kubeconfig. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool. This environment is separate from the ungraded playground.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-lab-020-05-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-lab-020-05-01" || exit 1
```

Keep this connection selected throughout the task. Every script supplied by the lab refuses a different context.

## Required result

Use the Deployment rollout history to return `probe` to the Pod template of revision one: image `docker.io/library/python:3.13-alpine` and `VERSION` set to `v1`. Wait until two replicas are updated, ready and available. Then set the annotation `kubernetes.io/change-cause` on Deployment `probe` to `rolled back to v1`. Do not delete the Deployment. The `shuttle` client must receive version v1.

## Verify The Result

The grader checks the stated resource fields and live evidence. Wait for controllers to finish before submitting. Inspect the actual results with kubectl instead of assuming they match this task text.
