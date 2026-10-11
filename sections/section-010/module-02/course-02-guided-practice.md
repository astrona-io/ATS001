---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green
  or canary)
---
# Switch A Service Between Ready Versions

The playground starts with the probe Deployment and a Service that selects only that release. You will create a second ready version, inspect its EndpointSlices and move the Service selector. This changes where new Service connections go; it does not copy persistent data or prove that old client connections have ended.

Use the module playground and its private kubeconfig. The context check below prevents commands from being directed at an unrelated cluster. The helper retries a command for a bounded interval after controller or policy changes; it cannot turn a persistent failure into success. Read the actual errors when the interval expires.

<!-- astrona:playground:renew -->

For a timed catalog session, renew this module before continuing. Skip renewal for an untimed local author run:

```sh
astrona run renew astrona-io/ATS001/section-010/module-02/playground
```

Select the module environment and define a bounded retry helper:

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-playground-010-02)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-010-02"
kubectl -n starfleet get pods
wait_for_success() {
  for attempt in 1 2 3 4 5 6 7 8 9 10; do
    if "$@"; then return 0; fi
    sleep 1
  done
  return 1
}
```

Save a separate green Deployment. Its release label differs from the original Deployment, while both applications use the same named HTTP port. Keeping independent selectors prevents the controllers from trying to own the same Pods. Wait for the green workload before changing the traffic selection.

Save this as `deployment-probe-green.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: probe-green
  namespace: starfleet
spec:
  replicas: 2
  selector:
    matchLabels:
      app: probe
      release: probe-green
  template:
    metadata:
      labels:
        app: probe
        release: probe-green
    spec:
      containers:
      - name: probe
        image: docker.io/library/python:3.13-alpine
        command:
        - python
        - /app/server.py
        env:
        - name: VERSION
          value: v2
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

Apply or use the saved input, then check the result:

```sh
kubectl apply -f deployment-probe-green.yaml
kubectl -n starfleet rollout status deployment/probe-green --timeout=120s
```

Inspect readiness rather than assuming that creating the Deployment made its containers usable. The old Service still selects the original release at this point, so preparation and exposure remain separate decisions.

Change the Service selector, then inspect the selected endpoints and make a new request from shuttle. The client reaches port 80 on the Service, which forwards to the named container port 8080. The response identifies the serving application version and hostname.

```sh
kubectl -n starfleet patch service probe -p '{"spec":{"selector":{"app":"probe","release":"probe-green"}}}'
kubectl -n starfleet get endpointslice -l kubernetes.io/service-name=probe -o yaml
wait_for_success bash -c 'kubectl -n starfleet exec shuttle -- wget -qO- http://probe/ | grep -q "version=v2"'
wait_for_success kubectl -n starfleet exec shuttle -- wget -qO- http://probe/
```

A response identifying v2 supports the result of this new request. Compare the endpoints with the green Pod addresses. This observation is narrower than proving that every long-lived connection has moved.

Restore the original selector while both Deployments still exist. This gives the traffic decision a controlled reversal without deleting the prepared version.

```sh
kubectl -n starfleet patch service probe -p '{"spec":{"selector":{"app":"probe","release":"probe"}}}'
wait_for_success kubectl -n starfleet exec shuttle -- wget -qO- http://probe/
```

The returned version should now identify the original workload. If it does not, inspect selector labels and ready endpoints before changing images or deleting Pods.

The important evidence is the relationship between selector, ready endpoint and request. A traffic reversal only restores the selected application path. It cannot reverse database writes or other side effects that occurred while the new release was exposed.

## Common pitfalls

> [!WARNING]
> Keep the selected module context and inspect the observed outcome. Resource acceptance does not establish readiness or a successful request. Reset this isolated environment if earlier experiments changed the required starting state.
