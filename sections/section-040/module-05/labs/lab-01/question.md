---
draft: true
exam_objectives:
- Use the Helm package manager to deploy existing packages
---
# Package A Chart And Install It From The Archive

The team received the source of the `fleet-chart` chart and must install it from a packaged archive, not from the directory.

## Objective

Package a chart at a new version, install the archive as a release with a values file and verify the release.

## Starting state

The cluster is healthy and the `starfleet` namespace exists. No release named `fleet` exists.

Use a host shell with this lab's private kubeconfig. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool. This environment is separate from the ungraded playground.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-lab-040-05-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-lab-040-05-01" || exit 1
```

Keep this connection selected throughout the task. Every script supplied by the lab refuses a different context.

Save this as `fleet-chart/Chart.yaml`:

```yaml
apiVersion: v2
name: fleet-chart
version: 0.1.0
appVersion: v1
type: application
```

Save this as `fleet-chart/values.yaml`:

```yaml
replicaCount: 1
version: v1
```

Save this as `fleet-chart/templates/application.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: fleet-probe
  namespace: {{ .Release.Namespace }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: fleet-probe
  template:
    metadata:
      labels:
        app: fleet-probe
    spec:
      containers:
      - name: probe
        image: docker.io/library/busybox:1.37.0
        command: ["sh", "-c", "sleep 3600"]
        env:
        - name: VERSION
          value: {{ .Values.version | quote }}
```

## Required result

Change the chart version in `Chart.yaml` to `0.2.0`. Run `helm lint` and package the chart into an archive. Save a values file named `fleet-values.yaml` that sets `replicaCount` to 3 and `version` to `v2`. Install the archive as release `fleet` in the `starfleet` namespace with that values file. Do not install from the directory. Grading checks the release chart name and version, the supplied values, the Deployment `fleet-probe` and its three replicas.

## Verify The Result

Wait until the Deployment is ready before you submit. Inspect actual results rather than relying on a sample transcript.
