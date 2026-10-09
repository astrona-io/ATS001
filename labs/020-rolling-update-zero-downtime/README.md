# Rolling Update Zero Downtime

This lab is part of the **Application Deployment** CKAD domain. It is written as a study document first and a command reference second. Work through the reasoning steps before using the guided solution.

For the CKAD exam, remember this sentence:

> A Deployment rollout changes Pods only when the Pod template changes.

## What You Learn

Deployments roll out ReplicaSet changes gradually. `maxSurge` controls how many extra Pods may exist during rollout. `maxUnavailable` controls how many desired Pods may be unavailable.

## Lab Files

| File | Purpose |
| --- | --- |
| `manifests/lab-start.yaml` | Creates the starting state for the exercise |
| `manifests/solution.yaml` | Shows one complete resource-based solution |

## Concept Overview

Changing the Deployment strategy alone does not always create a new ReplicaSet. A rollout is triggered by changing the Pod template. `kubectl set env` changes `.spec.template.spec.containers[].env`, so Kubernetes creates a new ReplicaSet.

With `replicas: 4`, `maxSurge: 2` permits as many as 6 Pods during the rollout. `maxUnavailable: 0` tells Kubernetes not to voluntarily reduce available Pods below 4.

A useful way to read any CKAD task is:

1. Find the namespace.
2. Identify the Kubernetes object type.
3. Decide whether the change belongs to metadata, spec, Pod template, or container spec.
4. Apply the smallest correct change.
5. Verify with `kubectl get`, `describe`, logs, events, or JSONPath.

## Study First

**CKAD focus:** Deployment rollout strategy.

**Mental model:** A Deployment rollout is controlled by maxSurge and maxUnavailable during ReplicaSet replacement.

Before you look at the solution, write down the answers to these questions:

- How many desired replicas exist?
- How many extra Pods are allowed?
- What Pod template change triggers rollout?

## Prerequisites

- A running Kubernetes or Kind cluster
- `kubectl` configured for the cluster
- You are working from this lab directory: `application-deployment/02-rolling-update-zero-downtime`

## Step 1: Start The Lab

```bash
kubectl apply -f manifests/lab-start.yaml
kubectl -n mercury rollout status deployment/cassini
```

## Step 2: Inspect The Starting State

Before solving, inspect what already exists. This builds the habit you need during the exam.

```bash
kubectl -n mercury get deployment cassini -o yaml
kubectl -n mercury get replicasets
kubectl -n mercury rollout history deployment/cassini
```

Look for these details:

- Correct namespace
- Existing labels and selectors
- Current images, replicas, ports, or mounted resources
- Events that explain pending, failed, or rejected resources

## Step 3: Understand The Task

For Deployment `cassini` in namespace `mercury`:

- Keep `4` replicas.
- Allow up to `2` extra Pods during rollout.
- Allow `0` unavailable Pods.
- Trigger a rollout by setting container environment variable `APP_VERSION=2`.

Rewrite the task as a short checklist in your notes. For each item, write the object and field you expect to change.

## Step 4: Guided Solution

Patch the rolling update strategy:

```bash
kubectl -n mercury patch deployment cassini -p '{
  "spec": {
    "strategy": {
      "type": "RollingUpdate",
      "rollingUpdate": {
        "maxSurge": 2,
        "maxUnavailable": 0
      }
    }
  }
}'
```

Trigger the rollout:

```bash
kubectl -n mercury set env deployment/cassini APP_VERSION=2
kubectl -n mercury rollout status deployment/cassini
```

## Step 5: Verify The Result

```bash
kubectl -n mercury get deploy cassini -o jsonpath='{.spec.strategy}{"\n"}'
kubectl -n mercury get deploy cassini -o jsonpath='{.spec.template.spec.containers[0].env}{"\n"}'
kubectl -n mercury rollout history deployment/cassini
```

When verification fails, do not immediately rerun the solution. First compare the live object with the expected object.

## Troubleshooting

- If no new ReplicaSet appears, confirm you changed the Pod template, not only Deployment metadata.
- If rollout stalls, inspect Pod readiness and events.

## Common Mistakes

- Setting `maxUnavailable: 1`, which violates zero downtime.
- Editing the live Pod instead of the Deployment.
- Forgetting to trigger a new rollout after changing the strategy.

## Practice Variations

After you solve the lab once, repeat it with one or two small changes so the skill becomes flexible:

- Set maxSurge as a percentage.
- Use rollout pause and resume.
- Inspect ReplicaSets during the rollout.

## Cleanup

Remove the lab resources when finished:

```bash
kubectl delete namespace mercury
```

## CKAD Exam Notes

- Prefer fast imperative commands when they produce the correct object, but switch to YAML when field placement matters.
- Always include `-n <namespace>` for namespaced resources.
- Use `kubectl explain` if you are unsure where a field belongs.
- Verify the live cluster state; do not rely only on the command succeeding.

## References

- Kubernetes Deployments: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
- Pods: https://kubernetes.io/docs/concepts/workloads/pods/
