# Helm Local Chart Values Upgrade

This lab is part of the **Application Deployment** CKAD domain. It is written as a study document first and a command reference second. Work through the reasoning steps before using the guided solution.

For the CKAD exam, remember this sentence:

> Helm values feed templates; upgrades create release revisions.

## What You Learn

This lab makes Helm executable without an external chart repository. You install a local chart, override values, upgrade it, inspect history, and uninstall it.

## Lab Files

| File | Purpose |
| --- | --- |
| `charts/study-web/Chart.yaml` | Helm chart metadata |
| `charts/study-web/templates/deployment.yaml` | Supporting lab resource |
| `charts/study-web/templates/service.yaml` | Supporting lab resource |
| `charts/study-web/values.yaml` | Default Helm chart values |

## Concept Overview

Helm values let you change chart behavior without editing templates. `helm upgrade` creates a new release revision. `helm history` is useful when debugging failed or unexpected chart updates.

A useful way to read any CKAD task is:

1. Find the namespace.
2. Identify the Kubernetes object type.
3. Decide whether the change belongs to metadata, spec, Pod template, or container spec.
4. Apply the smallest correct change.
5. Verify with `kubectl get`, `describe`, logs, events, or JSONPath.

## Study First

**CKAD focus:** Local Helm chart practice.

**Mental model:** A chart template plus values produces Kubernetes manifests; release operations manage deployed revisions.

Before you look at the solution, write down the answers to these questions:

- Which fields are templated?
- Which values are overridden at install time?
- What changed between revisions?

## Prerequisites

- A running Kubernetes or Kind cluster
- `kubectl` configured for the cluster
- You are working from this lab directory: `application-deployment/06-helm-local-chart-values-upgrade`

## Step 1: Start The Lab

Create the namespace:

```bash
kubectl create namespace helm-lab
```

## Step 2: Inspect The Starting State

Before solving, inspect what already exists. This builds the habit you need during the exam.

```bash
helm lint charts/study-web
helm template study-web charts/study-web --set replicaCount=2
helm -n helm-lab get values study-web
```

Look for these details:

- Correct namespace
- Existing labels and selectors
- Current images, replicas, ports, or mounted resources
- Events that explain pending, failed, or rejected resources

## Step 3: Understand The Task

Using the local chart in `charts/study-web`:

- Install release `study-web` in namespace `helm-lab` with `2` replicas.
- Upgrade it to image tag `1.32-alpine` and `3` replicas.
- Inspect release history and rendered values.
- Uninstall the release.

Rewrite the task as a short checklist in your notes. For each item, write the object and field you expect to change.

## Step 4: Guided Solution

Install:

```bash
helm -n helm-lab install study-web charts/study-web --set replicaCount=2
```

Upgrade:

```bash
helm -n helm-lab upgrade study-web charts/study-web \
  --set replicaCount=3 \
  --set image.tag=1.32-alpine
```

Inspect:

```bash
helm -n helm-lab list
helm -n helm-lab history study-web
helm -n helm-lab get values study-web
kubectl -n helm-lab get deploy study-web -o wide
```

Uninstall:

```bash
helm -n helm-lab uninstall study-web
```

## Step 5: Verify The Result

```bash
helm lint charts/study-web
helm template study-web charts/study-web --set replicaCount=2
```

When verification fails, do not immediately rerun the solution. First compare the live object with the expected object.

## Troubleshooting

- If Helm cannot find the chart, check your path from the lab directory.
- If replicas do not change, inspect values and rendered Deployment.

## Practice Variations

After you solve the lab once, repeat it with one or two small changes so the skill becomes flexible:

- Render the chart with helm template only.
- Add a chart value for Service type.
- Rollback the release after upgrade.

## Cleanup

Remove the lab resources when finished:

```bash
helm -n helm-lab uninstall study-web && kubectl delete namespace helm-lab
```

## CKAD Exam Notes

- Prefer fast imperative commands when they produce the correct object, but switch to YAML when field placement matters.
- Always include `-n <namespace>` for namespaced resources.
- Use `kubectl explain` if you are unsure where a field belongs.
- Verify the live cluster state; do not rely only on the command succeeding.

## References

- Kubernetes Deployments: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
- Kubernetes Services: https://kubernetes.io/docs/concepts/services-networking/service/
- Helm documentation: https://helm.sh/docs/
