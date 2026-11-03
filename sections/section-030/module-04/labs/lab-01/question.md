---
draft: true
exam_objectives:
- Kustomize
---
# Generate A ConfigMap With Kustomize

The `probe` application in `starfleet` reads its greeting from `/settings/greeting`. Supply that file with a ConfigMap that Kustomize generates, and let the Deployment roll out with it.

## Objective

Generate a ConfigMap with a `configMapGenerator`, mount it in the `probe` Deployment and apply the result with `kubectl apply -k`.

## Starting state

The `probe` Deployment, its Service and a client Pod named `shuttle` are healthy. The Deployment has no settings volume yet, so the application answers with its default greeting.

Use a host shell with this lab's private kubeconfig. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool. This environment is separate from the ungraded playground.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-lab-030-04-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-lab-030-04-01" || exit 1
```

Keep this connection selected throughout the task. Every script supplied by the lab refuses a different context.

Save the desired Deployment as `base/deployment-probe.yaml`. It already refers to a settings volume with the plain ConfigMap name `probe-settings`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: probe
  namespace: starfleet
spec:
  replicas: 2
  selector:
    matchLabels:
      app: probe
      release: probe
  template:
    metadata:
      labels:
        app: probe
        release: probe
    spec:
      containers:
      - name: probe
        image: docker.io/library/python:3.13-alpine
        command:
        - python
        - /app/server.py
        env:
        - name: VERSION
          value: v1
        ports:
        - name: http
          containerPort: 8080
        readinessProbe:
          httpGet:
            path: /ready
            port: http
          periodSeconds: 2
        volumeMounts:
        - name: app
          mountPath: /app
          readOnly: true
        - name: settings
          mountPath: /settings
          readOnly: true
      volumes:
      - name: app
        configMap:
          name: probe-code
      - name: settings
        configMap:
          name: probe-settings
```

## Required result

Create `base/kustomization.yaml` that lists the Deployment file, sets the namespace `starfleet` and generates a ConfigMap named `probe-settings` with the literal `greeting=hello-fleet`. Keep the generated hash suffix. Apply the directory with `kubectl apply -k base`. Grading checks that the Deployment uses the hashed ConfigMap name, that the ConfigMap holds the greeting, and that a request from `shuttle` to `http://probe/` returns `greeting=hello-fleet`.

## Verify The Result

Wait for the rollout to finish before you submit. Inspect actual results rather than relying on a sample transcript.
