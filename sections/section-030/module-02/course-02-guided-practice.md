---
draft: true
exam_objectives:
- Kustomize
---
# Render And Apply A Self-Contained Kustomize Base

Kustomize composes Kubernetes declarations without turning the source files into application processes. You will write a local base from complete resources, render a prefixed environment and inspect what was applied. The playground already supplies the probe-code ConfigMap used by the application.

Use the module playground and its private kubeconfig. The context check below prevents commands from being directed at an unrelated cluster. The helper retries a command for a bounded interval after controller or policy changes; it cannot turn a persistent failure into success. Read the actual errors when the interval expires.

Kustomize output is ordinary Kubernetes YAML. Rendering on your machine does not send objects to the cluster; applying the saved composition does. Inspect final names and references before submission, especially the link from a Deployment volume to a generated ConfigMap.

A generated name changes when its configuration content changes under the hashing strategy. If that new name enters a Deployment's Pod template, applying the result can trigger replacement. This differs from editing a fixed-name ConfigMap while leaving the template unchanged.

<!-- astrona:playground:renew -->

For a timed catalog session, renew this module before continuing. Skip renewal for an untimed local author run:

```sh
astrona run renew astrona-io/ATS001/section-030/module-02/playground
```

Select the module environment and define a bounded retry helper:

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-playground-030-02)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-030-02"
kubectl -n starfleet get pods
wait_for_success() {
  for attempt in 1 2 3 4 5 6 7 8 9 10; do
    if "$@"; then return 0; fi
    sleep 1
  done
  return 1
}
```

Create a directory and save its Deployment, Service and kustomization files. The resources keep matching selectors and named ports. These are local files you create, so the exercise does not depend on files hidden in a downloaded playground.

```sh
mkdir -p probe-base
```

Save this as `probe-base/deployment-probe.yaml`:

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

Save this as `probe-base/service-probe.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: probe
  namespace: starfleet
spec:
  selector:
    app: probe
    release: probe
  ports:
  - name: http
    port: 80
    targetPort: http
```

Save this as `probe-base/kustomization.yaml`:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- deployment-probe.yaml
- service-probe.yaml
namePrefix: dev-
```

A directory name alone has no rendering meaning. The kustomization file selects which resources belong to the base.

Render the base, then apply that same composition to the practice namespace. Inspect the generated names instead of guessing them from source filenames.

```sh
kubectl kustomize probe-base
kubectl apply -k probe-base
kubectl -n starfleet rollout status deployment/dev-probe --timeout=120s
kubectl -n starfleet get deployment dev-probe -o yaml
```

The name prefix changes object names. It does not automatically provide tenant isolation or separate all selector relationships. Compare the generated selectors and the original resources explicitly.

Remove only the composition you created. The original probe workload remains available because its name differs.

```sh
kubectl delete -k probe-base
kubectl -n starfleet get deployment probe
```

Deletion follows the rendered resource identities. It does not delete the unrelated source ConfigMap or restore data written by an application.

Use render output to understand intent, apply to ask the API server to realize it, and status to assess progress. Those are separate observations. A base can be reusable while still depending on declared external inputs such as a ConfigMap or secret.

## Common pitfalls

> [!WARNING]
> Keep the selected module context and inspect the observed outcome. Resource acceptance does not establish readiness or a successful request. Reset this isolated environment if earlier experiments changed the required starting state.
