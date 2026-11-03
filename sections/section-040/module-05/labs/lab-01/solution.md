---
draft: true
exam_objectives:
- Use the Helm package manager to deploy existing packages
---
# Package A Chart And Install It From The Archive Solution

Select the lab's private kubeconfig.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-lab-040-05-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-lab-040-05-01" || exit 1
```

## Inspect and explain

The archive name comes from `name` and `version` in `Chart.yaml`, so the version must be changed before packaging. Change the line `version: 0.1.0` to `version: 0.2.0`, then check the chart and package it.

```sh
helm lint fleet-chart
helm package fleet-chart
```

The second command writes `fleet-chart-0.2.0.tgz` in the current directory. Save this as `fleet-values.yaml`:

```yaml
replicaCount: 3
version: v2
```

Install the archive with the values file.

```sh
helm install fleet ./fleet-chart-0.2.0.tgz -n starfleet -f fleet-values.yaml --wait --timeout 3m
```

## Verify the result

```sh
helm list -n starfleet
helm get values fleet -n starfleet
kubectl -n starfleet get deployment fleet-probe
```

The release list shows `fleet` with the chart `fleet-chart-0.2.0`. The supplied values are the two values from the file, and the Deployment has three ready replicas. After recording the result, remove this lab with `astrona destroy ats-001-lab-040-05-01`.

## Common pitfalls

> [!WARNING]
> If you forget to raise the version, the archive is named `fleet-chart-0.1.0.tgz` and the grader reports the wrong chart version. If `helm install` reports that the release already exists, check `helm list -n starfleet` before you retry.
