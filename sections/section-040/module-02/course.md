# Helm Release Operations

This lab is part of the **Application Deployment** CKAD domain. It is written as a study document first and a command reference second. Work through the reasoning steps before using the guided solution.

For the CKAD exam, remember this sentence:

> Helm actions operate on releases; Kubernetes objects are the rendered result.

## What You Learn

Helm manages Kubernetes applications as releases. This lab is command-focused because the external chart repository is environment-specific.

## Lab Files

This lab is command-focused and does not require additional resource files.

## Concept Overview

`helm list --all` shows releases in non-deployed states, including `pending-install`. `helm upgrade` changes an existing release. `helm install` creates a new one.

Values vary by chart. Common keys are `replicaCount` or `replicas`; inspect defaults when unsure:

```bash
helm show values study-charts/apache
```

A useful way to read any CKAD task is:

1. Find the namespace.
2. Identify the Kubernetes object type.
3. Decide whether the change belongs to metadata, spec, Pod template, or container spec.
4. Apply the smallest correct change.
5. Verify with `kubectl get`, `describe`, logs, events, or JSONPath.

## Study First

**CKAD focus:** Helm release lifecycle.

**Mental model:** Helm stores each install or upgrade as a release revision, separate from raw Kubernetes object editing.

Before you look at the solution, write down the answers to these questions:

- What namespace contains the release?
- Is the action install, upgrade, rollback, or uninstall?
- Which values does the chart actually support?

## Prerequisites

- A running Kubernetes or Kind cluster
- `kubectl` configured for the cluster
- You are working from this lab directory: `application-deployment/03-helm-release-operations`

## Step 1: Start The Lab

Add the chart repository if your environment provides it:

```bash
helm repo add study-charts https://example.invalid/charts
helm repo update
```

Replace the URL with the chart repository available in your training cluster.

## Step 2: Inspect The Starting State

Before solving, inspect what already exists. This builds the habit you need during the exam.

```bash
helm -n birch list --all
helm -n birch history internal-issue-report-apiv2
helm show values study-charts/apache
```

Look for these details:

- Correct namespace
- Existing labels and selectors
- Current images, replicas, ports, or mounted resources
- Events that explain pending, failed, or rejected resources

## Step 3: Understand The Task

In namespace `birch`:

- Delete release `internal-issue-report-apiv1`.
- Upgrade release `internal-issue-report-apiv2` to a newer available version of chart `study-charts/nginx`.
- Install release `internal-issue-report-apache` from chart `study-charts/apache` with two replicas using Helm values.
- Find and delete a release stuck in `pending-install`.

Rewrite the task as a short checklist in your notes. For each item, write the object and field you expect to change.

## Step 4: Guided Solution

```bash
helm -n birch uninstall internal-issue-report-apiv1
helm search repo study-charts/nginx --versions
helm -n birch upgrade internal-issue-report-apiv2 study-charts/nginx
helm -n birch install internal-issue-report-apache study-charts/apache --set replicaCount=2
helm -n birch list --all
```

Delete the stuck release after finding its name:

```bash
helm -n birch uninstall RELEASE_NAME
```

## Step 5: Verify The Result

Use `kubectl get`, `kubectl describe`, JSONPath, logs, or events to prove the task is complete.

When verification fails, do not immediately rerun the solution. First compare the live object with the expected object.

## Troubleshooting

- If a value does not work, inspect the chart default values.
- If a release is stuck, list all release states, not only deployed releases.

## Practice Variations

After you solve the lab once, repeat it with one or two small changes so the skill becomes flexible:

- Run helm get manifest for a release.
- Use --dry-run before upgrade.
- Rollback to a previous revision.

## Cleanup

Remove the lab resources when finished:

```bash
helm -n birch list --all
```

## CKAD Exam Notes

- Prefer fast imperative commands when they produce the correct object, but switch to YAML when field placement matters.
- Always include `-n <namespace>` for namespaced resources.
- Use `kubectl explain` if you are unsure where a field belongs.
- Verify the live cluster state; do not rely only on the command succeeding.

## References

- Kubernetes Deployments: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
- Helm documentation: https://helm.sh/docs/
