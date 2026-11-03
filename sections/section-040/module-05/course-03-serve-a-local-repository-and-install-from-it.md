---
draft: true
exam_objectives:
- Use the Helm package manager to deploy existing packages
---
# Serve A Local Repository And Install From It

You will build a chart, package it, publish it from a local HTTP server and then install it as if it came from a team repository. This uses only your own machine and the playground cluster, so it works without access to any public repository. You need two terminal windows, one for the server and one for the commands.

Use the playground and its private kubeconfig in the command window.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-playground-040-05)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-040-05"
mkdir -p crew-chart/templates repository
```

Save this as `crew-chart/Chart.yaml`:

```yaml
apiVersion: v2
name: crew-chart
version: 0.1.0
appVersion: v1
type: application
```

Save this as `crew-chart/values.yaml`:

```yaml
replicaCount: 1
version: v1
```

Save this as `crew-chart/templates/application.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: crew-probe
  namespace: {{ .Release.Namespace }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: crew-probe
  template:
    metadata:
      labels:
        app: crew-probe
    spec:
      containers:
      - name: probe
        image: docker.io/library/busybox:1.37.0
        command: ["sh", "-c", "sleep 3600"]
        env:
        - name: VERSION
          value: {{ .Values.version | quote }}
```

Check the chart, package it into the `repository` directory and generate the index file. The index command reads every archive in the directory.

```sh
helm lint crew-chart
helm package crew-chart --destination repository
helm repo index repository
```

The `repository` directory now holds `crew-chart-0.1.0.tgz` and `index.yaml`. In the second terminal, start a web server that serves this directory on port 8879. It keeps running until you stop it.

```sh
python3 -m http.server 8879 --directory repository
```

Back in the command window, register the repository, search it and read the values.

```sh
helm repo add local-crew http://127.0.0.1:8879
helm repo update local-crew
helm search repo local-crew/crew-chart
helm show values local-crew/crew-chart
```

Save this as `crew-values.yaml`:

```yaml
replicaCount: 2
version: v2
```

Install version 0.1.0 with the values file:

```sh
helm install crew local-crew/crew-chart --version 0.1.0 -n starfleet -f crew-values.yaml --wait --timeout 3m
```

Then read what Helm recorded:

```sh
helm list -n starfleet
helm get values crew -n starfleet
kubectl -n starfleet get deployment crew-probe
```

The release list should show `crew` with the chart `crew-chart-0.1.0`. The recorded values should be the two values from the file, and the Deployment should have two replicas. Remove the release and the repository registration when you finish, then stop the server with Ctrl+C.

```sh
helm uninstall crew -n starfleet
helm repo remove local-crew
```

## Common pitfalls

> [!WARNING]
> If `helm repo add` fails, the server is not running or uses a different port. If a new chart version does not appear after you package it, run `helm repo index repository` again and then `helm repo update`.
