---
draft: true
exam_objectives:
- Kustomize
---
# Kustomize Section Capstone: Production Overlay

The `probe` application in `starfleet` runs from a shared base. Production needs a different version, more replicas, a generated settings file and a label, and the base must stay unchanged for other environments.

## Objective

Build a `production` overlay that combines a patch, a generator and a label transformer, and apply it with `kubectl apply -k`.

## Starting state

The `probe` Deployment, its Service and the client Pod `shuttle` are healthy and run the base configuration with two replicas and `VERSION=v1`.

Use a host shell with this lab's private kubeconfig. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool. This environment is separate from the ungraded playground.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-lab-030-capstone-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-lab-030-capstone-01" || exit 1
```

Keep this connection selected throughout the task. Every script supplied by the lab refuses a different context.

Save this as `base/deployment-probe.yaml`:

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
        resources:
          requests:
            cpu: 10m
            memory: 32Mi
          limits:
            memory: 128Mi
        volumeMounts:
        - name: app
          mountPath: /app
          readOnly: true
      volumes:
      - name: app
        configMap:
          name: probe-code
```

Save this as `base/kustomization.yaml`. The namespace line makes the generated ConfigMap land in `starfleet`:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- deployment-probe.yaml
namespace: starfleet
```

## Required result

Create `production/kustomization.yaml` that includes the base and does all of the following without editing any file in `base`. Set the replica count to 3 and `VERSION` to `v2`. Mount a ConfigMap at `/settings` through a volume named `settings`; generate that ConfigMap with the name `probe-settings` and the literal `greeting=hello-production`, and keep the hash suffix. Add the label `tier: production` to the Pod template labels without changing the Deployment selector. Keep the existing `app` volume and mount. Apply the overlay with `kubectl apply -k production`. Grading checks the Deployment fields and that a request from `shuttle` to `http://probe/` returns `version=v2` and `greeting=hello-production`.

## Verify The Result

Render the overlay with `kubectl kustomize production` before you apply it. Wait for the rollout to finish before you submit.
