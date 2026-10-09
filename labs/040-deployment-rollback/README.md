# Deployment Rollback

This lab is part of the **Application Deployment** CKAD domain. It is written as a study document first and a command reference second. Work through the reasoning steps before using the guided solution.

For the CKAD exam, remember this sentence:

> Rollback returns the Deployment Pod template to an earlier revision.

## What You Learn

Deployment history lets you roll back a bad rollout to an earlier ReplicaSet.

## Lab Files

| File | Purpose |
| --- | --- |
| `manifests/lab-start.yaml` | Creates the starting state for the exercise |

## Concept Overview

`rollout undo` changes the Deployment Pod template back to an older revision. Check history first so you understand which revision is broken and which revision is likely working.

A useful way to read any CKAD task is:

1. Find the namespace.
2. Identify the Kubernetes object type.
3. Decide whether the change belongs to metadata, spec, Pod template, or container spec.
4. Apply the smallest correct change.
5. Verify with `kubectl get`, `describe`, logs, events, or JSONPath.

## Study First

**CKAD focus:** Rollback from failed rollout.

**Mental model:** Deployment history records Pod template revisions and lets you return to an earlier known-good template.

Before you look at the solution, write down the answers to these questions:

- Is the current rollout complete?
- Which revision introduced the problem?
- Should you undo latest or target a specific revision?

## Prerequisites

- A running Kubernetes or Kind cluster
- `kubectl` configured for the cluster
- You are working from this lab directory: `application-deployment/04-deployment-rollback`

## Step 1: Start The Lab

```bash
kubectl apply -f manifests/lab-start.yaml
kubectl -n aspen rollout status deployment/api-new-c32 --timeout=20s
```

The rollout may fail because the readiness probe is intentionally bad. To create a rollback history in a fresh cluster, first apply a working version, then apply the broken version.

## Step 2: Inspect The Starting State

Before solving, inspect what already exists. This builds the habit you need during the exam.

```bash
kubectl -n aspen rollout status deployment/api-new-c32
kubectl -n aspen rollout history deployment/api-new-c32
kubectl -n aspen get replicasets
```

Look for these details:

- Correct namespace
- Existing labels and selectors
- Current images, replicas, ports, or mounted resources
- Events that explain pending, failed, or rejected resources

## Step 3: Understand The Task

Deployment `api-new-c32` in namespace `aspen` has a recent update that never came online. Check rollout history and roll back to a working revision.

Rewrite the task as a short checklist in your notes. For each item, write the object and field you expect to change.

## Step 4: Guided Solution

```bash
kubectl -n aspen rollout history deployment/api-new-c32
kubectl -n aspen rollout undo deployment/api-new-c32
kubectl -n aspen rollout status deployment/api-new-c32
```

Rollback to a specific revision:

```bash
kubectl -n aspen rollout undo deployment/api-new-c32 --to-revision=REVISION
```

## Step 5: Verify The Result

```bash
kubectl -n aspen get deploy api-new-c32
kubectl -n aspen rollout history deployment/api-new-c32
```

When verification fails, do not immediately rerun the solution. First compare the live object with the expected object.

## Troubleshooting

- If undo does nothing, there may be no previous revision in a fresh lab.
- Use --to-revision when the latest previous revision is not the desired one.

## Practice Variations

After you solve the lab once, repeat it with one or two small changes so the skill becomes flexible:

- Use rollout history --revision.
- Break the image and roll back.
- Compare ReplicaSets before and after undo.

## Cleanup

Remove the lab resources when finished:

```bash
kubectl delete namespace aspen
```

## CKAD Exam Notes

- Prefer fast imperative commands when they produce the correct object, but switch to YAML when field placement matters.
- Always include `-n <namespace>` for namespaced resources.
- Use `kubectl explain` if you are unsure where a field belongs.
- Verify the live cluster state; do not rely only on the command succeeding.

## References

- Kubernetes Deployments: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
- Pods: https://kubernetes.io/docs/concepts/workloads/pods/
- Liveness, readiness, and startup probes: https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/
