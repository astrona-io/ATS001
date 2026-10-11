---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green
  or canary)
---
# Observe Canary Backends Without Assuming Exact Percentages

Ordinary Services distribute connections across eligible ready endpoints without offering an exact application-level percentage contract. You will add a one-replica canary beside the stable release, widen the selector and sample fresh requests. Endpoint counts explain eligibility; request samples are observations rather than guaranteed traffic weights.

Use the module playground and its private kubeconfig. The context check below prevents commands from being directed at an unrelated cluster. The helper retries a command for a bounded interval after controller or policy changes; it cannot turn a persistent failure into success. Read the actual errors when the interval expires.

<!-- astrona:playground:renew -->

For a timed catalog session, renew this module before continuing. Skip renewal for an untimed local author run:

```sh
astrona run renew astrona-io/ATS001/section-010/module-03/playground
```

Select the module environment and define a bounded retry helper:

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-playground-010-03)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-010-03"
kubectl -n starfleet get pods
wait_for_success() {
  for attempt in 1 2 3 4 5 6 7 8 9 10; do
    if "$@"; then return 0; fi
    sleep 1
  done
  return 1
}
```

Create a separate one-replica canary. Its controller selector must remain distinct from the stable Deployment. Once it is ready, the Service can deliberately select both versions through their shared app label.

Save this as `deployment-probe-canary.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: probe-canary
  namespace: starfleet
spec:
  replicas: 1
  selector:
    matchLabels:
      app: probe
      release: probe-canary
  template:
    metadata:
      labels:
        app: probe
        release: probe-canary
    spec:
      containers:
      - name: probe
        image: docker.io/library/python:3.13-alpine
        command:
        - python
        - /app/server.py
        env:
        - name: VERSION
          value: canary
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

Save this as `service-probe-shared.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: probe
  namespace: starfleet
spec:
  selector:
    app: probe
  ports:
  - name: http
    port: 80
    targetPort: http
```

Apply or use the saved input, then check the result:

```sh
kubectl apply -f deployment-probe-canary.yaml
kubectl -n starfleet rollout status deployment/probe-canary --timeout=120s
kubectl apply -f service-probe-shared.yaml
```

The Service file replaces the selector with the shared label. Compare the ready Pods before interpreting exposure. An unready canary should not be counted as an available backend.

Read EndpointSlices and sample separate HTTP requests. Each wget invocation creates a new request process, but networking and connection selection still do not establish a precise distribution guarantee.

```sh
kubectl -n starfleet get endpointslice -l kubernetes.io/service-name=probe -o yaml
kubectl -n starfleet exec shuttle -- sh -c 'for attempt in 1 2 3 4 5 6 7 8 9 10; do wget -qO- http://probe/; done'
```

Count responses by version only as a small sample. Failure to observe the canary in ten requests is not proof that its endpoint is absent. Endpoint evidence and request evidence answer different questions.

Withdraw the canary by restoring a stable-only selector. Leave the Deployment available for inspection instead of equating withdrawal with deleting all release state.

```sh
kubectl -n starfleet patch service probe -p '{"spec":{"selector":{"app":"probe","release":"probe"}}}'
wait_for_success kubectl -n starfleet exec shuttle -- wget -qO- http://probe/
```

Use another fresh request to check the selected version. The selector now narrows the eligible population even though the canary Pod still exists.

An approximate endpoint fraction can help plan an experiment, but it is not a configured traffic percentage. Promotion needs evidence from the intended population and a deliberate release decision. This exercise demonstrates selection and withdrawal without inventing performance results.

## Common pitfalls

> [!WARNING]
> Keep the selected module context and inspect the observed outcome. Resource acceptance does not establish readiness or a successful request. Reset this isolated environment if earlier experiments changed the required starting state.
