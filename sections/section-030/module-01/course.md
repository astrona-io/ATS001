# Canary Kustomize

This lab is part of the **Application Deployment** CKAD domain. It is written as a study document first and a command reference second. Work through the reasoning steps before using the guided solution.

For the CKAD exam, remember this sentence:

> Canary percentage can be approximated by selected Pod counts when Pods are equivalent endpoints.

## What You Learn

Kustomize overlays customize a base manifest without copying it. Canary rollouts often change replica counts and Service selectors to control how much traffic reaches canary Pods.

## Lab Files

| File | Purpose |
| --- | --- |
| `tea-one/base/app.yaml` | Supporting lab resource |
| `tea-one/base/kustomization.yaml` | Defines a Kustomize layer |
| `tea-one/base/namespace.yaml` | Supporting lab resource |
| `tea-one/overlays/prod/kustomization.yaml` | Defines a Kustomize layer |
| `tea-one/overlays/prod/patch.yaml` | Supporting lab resource |
| `tea-two/base/app.yaml` | Supporting lab resource |
| `tea-two/base/kustomization.yaml` | Defines a Kustomize layer |
| `tea-two/base/namespace.yaml` | Supporting lab resource |
| `tea-two/overlays/prod/kustomization.yaml` | Defines a Kustomize layer |
| `tea-two/overlays/prod/patch.yaml` | Supporting lab resource |

## Concept Overview

Traffic percentage is approximated by matching Pod counts when all selected Pods are equivalent Service endpoints. For 20 percent canary with 10 total Pods, use 2 canary Pods and 8 stable Pods.

For 0 percent canary, either scale canary to 0 or adjust the Service selector away from canary. This lab uses both for an explicit rollback.

A useful way to read any CKAD task is:

1. Find the namespace.
2. Identify the Kubernetes object type.
3. Decide whether the change belongs to metadata, spec, Pod template, or container spec.
4. Apply the smallest correct change.
5. Verify with `kubectl get`, `describe`, logs, events, or JSONPath.

## Study First

**CKAD focus:** Kustomize overlay driven canary.

**Mental model:** Kustomize lets you keep a reusable base and apply environment-specific patches for rollout shape.

Before you look at the solution, write down the answers to these questions:

- Which overlay is prod?
- How many stable and canary Pods produce the target percentage?
- Should the Service select canary Pods?

## Prerequisites

- A running Kubernetes or Kind cluster
- `kubectl` configured for the cluster
- You are working from this lab directory: `application-deployment/05-canary-kustomize`

## Step 1: Start The Lab

This lab provides two Kustomize trees:

- `tea-one/`
- `tea-two/`

Apply each prod overlay:

```bash
kubectl apply -k tea-one/overlays/prod
kubectl apply -k tea-two/overlays/prod
```

## Step 2: Inspect The Starting State

Before solving, inspect what already exists. This builds the habit you need during the exam.

```bash
kubectl kustomize tea-one/overlays/prod
kubectl kustomize tea-two/overlays/prod
kubectl -n tea-two get deploy,svc,pod --show-labels
```

Look for these details:

- Correct namespace
- Existing labels and selectors
- Current images, replicas, ports, or mounted resources
- Events that explain pending, failed, or rejected resources

## Step 3: Understand The Task

Update both prod overlays:

- `tea-one`: 4 total Pods, 0 percent traffic to canary, full rollback.
- `tea-two`: 10 total Pods, 20 percent traffic to canary.

Rewrite the task as a short checklist in your notes. For each item, write the object and field you expect to change.

## Step 4: Guided Solution

For `tea-one`, set stable replicas to `4`, canary replicas to `0`, and make the Service select only stable Pods.

For `tea-two`, set stable replicas to `8`, canary replicas to `2`, and make the Service select both stable and canary Pods by selecting only the shared app label.

Apply:

```bash
kubectl apply -k tea-one/overlays/prod
kubectl apply -k tea-two/overlays/prod
```

## Step 5: Verify The Result

```bash
kubectl -n tea-one get deploy,svc,pod --show-labels
kubectl -n tea-two get deploy,svc,pod --show-labels
```

When verification fails, do not immediately rerun the solution. First compare the live object with the expected object.

## Troubleshooting

- If Service traffic percentage is wrong, check both replica counts and Service selectors.
- If kustomize output is unexpected, render before applying.

## Practice Variations

After you solve the lab once, repeat it with one or two small changes so the skill becomes flexible:

- Change tea-two to 50 percent canary.
- Use kubectl diff -k before apply.
- Move common labels into the base.

## Cleanup

Remove the lab resources when finished:

```bash
kubectl delete namespace tea-one tea-two
```

## CKAD Exam Notes

- Prefer fast imperative commands when they produce the correct object, but switch to YAML when field placement matters.
- Always include `-n <namespace>` for namespaced resources.
- Use `kubectl explain` if you are unsure where a field belongs.
- Verify the live cluster state; do not rely only on the command succeeding.

## References

- Kubernetes Deployments: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
- Kubernetes Services: https://kubernetes.io/docs/concepts/services-networking/service/
- Labels and selectors: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/
- Pods: https://kubernetes.io/docs/concepts/workloads/pods/
- Kustomize: https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/
