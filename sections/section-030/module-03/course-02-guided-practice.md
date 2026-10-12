---
draft: true
exam_objectives:
- Kustomize
---
# Patch One Environment Without Editing Its Base

An overlay records a focused difference while keeping the base unchanged. You will create a complete local base and an environment overlay that changes replica count and a container environment value. Rendering makes the target and resulting field changes visible before application.

Use the module playground and its private kubeconfig. The context check below prevents commands from being directed at an unrelated cluster. The helper retries a command for a bounded interval after controller or policy changes; it cannot turn a persistent failure into success. Read the actual errors when the interval expires.

Review a patch as a change to a complete object. The rendered replica count can be correct while a helper container disappeared or a selector changed unexpectedly. Check container names, ownership labels and Service selection alongside the intended field.

List merge behavior depends on the supported schema and patch format. A named container target expresses identity; a numeric JSON patch path expresses a position. Neither the shortness of the patch nor valid YAML proves that it changed the intended container.

<!-- astrona:playground:renew -->

For a timed catalog session, renew this module before continuing. Skip renewal for an untimed local author run:

```sh
astrona run renew astrona-io/ATS001/section-030/module-03/playground
```

Select the module environment and define a bounded retry helper:

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-playground-030-03)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-030-03"
kubectl -n starfleet get pods
wait_for_success() {
  for attempt in 1 2 3 4 5 6 7 8 9 10; do
    if "$@"; then return 0; fi
    sleep 1
  done
  return 1
}
```

Create the base and overlay directories, then save the selected resources and patch. The patch targets the Deployment by kind and name rather than matching an arbitrary document position.

```sh
mkdir -p base overlay
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

Save this as `overlay/patch-probe.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: probe
  namespace: starfleet
spec:
  replicas: 1
  template:
    spec:
      containers:
      - name: probe
        env:
        - name: VERSION
          value: overlay
```

Save this as `overlay/kustomization.yaml`:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- ../base
patches:
- path: patch-probe.yaml
```

The overlay references the base and declares a patch input. Editing the patch is a separate change from editing the reusable resource.

Render and apply the overlay. Then inspect both the desired count and the application response.

```sh
kubectl kustomize overlay
kubectl apply -k overlay
kubectl -n starfleet rollout status deployment/probe --timeout=120s
kubectl -n starfleet get deployment probe -o jsonpath='{.spec.replicas}{"\n"}'
wait_for_success kubectl -n starfleet exec shuttle -- wget -qO- http://probe/
```

The rendered result should request one replica with VERSION set to overlay. Readiness and a request are still required to observe the realized application condition.

Reapply the base to restore its declared count and environment value.

```sh
kubectl apply -k base
kubectl -n starfleet rollout status deployment/probe --timeout=120s
```

Restoring base configuration is a controlled update. It does not imply that every external effect of the overlay was undone.

A focused patch should have an identifiable target and a clear state difference. Render before applying when the composition is unfamiliar. If a patch does not produce the intended field, investigate its target and merge contract rather than treating successful YAML parsing as proof.

## Common pitfalls

> [!WARNING]
> Keep the selected module context and inspect the observed outcome. Resource acceptance does not establish readiness or a successful request. Reset this isolated environment if earlier experiments changed the required starting state.
