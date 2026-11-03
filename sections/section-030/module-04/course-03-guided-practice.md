---
draft: true
exam_objectives:
- Kustomize
---
# Generate Settings And Roll Them Out

The `probe` application in the `starfleet` namespace reads its greeting from a file at `/settings/greeting`. You will generate a ConfigMap that supplies that file, apply it, change the greeting and observe a rollout without editing the Deployment. The ConfigMap named `probe-code` already exists in the playground and holds the application code.

Use the module playground and its private kubeconfig. Select it and define a helper that retries a command for a short period.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-playground-030-04)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-030-04"
wait_for_success() {
  for attempt in 1 2 3 4 5 6 7 8 9 10; do
    if "$@"; then return 0; fi
    sleep 2
  done
  return 1
}
mkdir -p base
```

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

The volume `settings` refers to the plain name `probe-settings`. No such ConfigMap exists in the cluster. The generator in the next file creates it under a hashed name and rewrites this reference.

Save this as `base/kustomization.yaml`:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- deployment-probe.yaml
namespace: starfleet
configMapGenerator:
- name: probe-settings
  literals:
  - greeting=hello-fleet
```

Render the build and look for the hashed name:

```sh
kubectl kustomize base
```

Apply it:

```sh
kubectl apply -k base
```

Then check the result:

```sh
kubectl -n starfleet rollout status deployment/probe --timeout=120s
wait_for_success kubectl -n starfleet exec shuttle -- wget -qO- http://probe/
```

The response should contain `greeting=hello-fleet`. Now change `hello-fleet` to `hello-again` in `base/kustomization.yaml`, apply again:

```sh
kubectl apply -k base
```

Then watch the rollout and check the result:

```sh
kubectl -n starfleet rollout status deployment/probe --timeout=120s
wait_for_success kubectl -n starfleet exec shuttle -- wget -qO- http://probe/
kubectl -n starfleet get configmap
```

The response should now contain `greeting=hello-again`. The ConfigMap list shows two `probe-settings-` objects, because apply does not delete the old one. Pods were replaced because the Deployment's Pod template named a new ConfigMap.

## Common pitfalls

> [!WARNING]
> If the response still shows the old greeting, check that the rollout finished and that the request did not reach an old Pod. Compare the ConfigMap name in `kubectl -n starfleet get deployment probe -o yaml` with the names from `kubectl get configmap`.
