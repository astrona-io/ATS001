---
draft: true
exam_objectives:
- Kustomize
---
# Patch A Preview With Kustomize Solution

Use a host shell with this lab's private kubeconfig. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool. This environment is separate from the ungraded playground.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-lab-030-03-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-lab-030-03-01" || exit 1
```

Keep this connection selected throughout the task. Every script supplied by the lab refuses a different context.

## Inspect And Explain

The application and client fixtures are healthy. Complete the required change without replacing unrelated resources.

Inspect the relevant evidence:

```sh
kubectl -n starfleet get pods
kubectl -n starfleet get deployment probe -o yaml
```

An overlay includes its base and adds selected changes. The container name identifies which container receives the strategic merge patch. The base remains reusable because preview values live in the overlay. Rendering the base and overlay makes that difference visible before applying either one.


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

Save this as `base/kustomization.yaml`:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- deployment-probe.yaml
```

Save this as `preview/kustomization.yaml`:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- ../base
patches:
- path: patch-probe.yaml
```

Save this as `preview/patch-probe.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: probe
  namespace: starfleet
spec:
  replicas: 1
  template:
    metadata:
      labels:
        environment: preview
    spec:
      containers:
      - name: probe
        env:
        - name: VERSION
          value: preview
```

Apply the required change:

```sh
kubectl apply -k preview
```

## Verify The Result

Observe the actual result. A denied-request command returns a nonzero status when the denial works. Run denial checks separately from a shell sequence that stops on the first nonzero status.

```sh
kubectl -n starfleet rollout status deployment/probe --timeout=180s
kubectl -n starfleet exec shuttle -- wget -q -T 3 -O- http://probe/
```

Keep a two-replica version-one base. Create a preview overlay that patches `probe` to one replica, template label `environment: preview` and `VERSION=preview`. Apply the overlay without editing the base. The client must receive the preview version. Grading checks the deployed preview; the file layout is checked by the author render test.

After recording the result, remove this independent lab with `astrona destroy ats-001-lab-030-03-01`.

## Common pitfalls

> [!WARNING]
> Put preview changes in the overlay, and match the container name in the patch. Editing the base makes that preview setting apply to other environments using the same base.
