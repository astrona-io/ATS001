---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green
  or canary)
---
# Configure Stable And Canary Backends Solution

Use a host shell with this lab's private kubeconfig. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool. This environment is separate from the ungraded playground.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-lab-010-03-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-lab-010-03-01" || exit 1
```

Keep this connection selected throughout the task. Every script supplied by the lab refuses a different context.

## Inspect And Explain

The application and client fixtures are healthy. Complete the required change without replacing unrelated resources.

Inspect the relevant evidence:

```sh
kubectl -n starfleet get pods
kubectl -n starfleet get deployment probe -o yaml
```

Deployment selectors keep ownership separate while the Service selector includes both tracks. The ratio of eligible Pods describes capacity, but connection reuse and routing behavior affect observed requests. Check endpoint membership and a successful request rather than grading a random traffic sample.


Save this as `deployment-probe.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: probe
  namespace: starfleet
spec:
  replicas: 3
  selector:
    matchLabels:
      app: probe
      release: probe
  template:
    metadata:
      labels:
        app: probe
        release: probe
        track: shared
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
---
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
      release: canary
  template:
    metadata:
      labels:
        app: probe
        release: canary
        track: shared
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
---
apiVersion: v1
kind: Service
metadata:
  name: probe
  namespace: starfleet
spec:
  selector:
    app: probe
    track: shared
  ports:
  - name: http
    port: 80
    targetPort: http
```

Apply the required change:

```sh
kubectl apply -f deployment-probe.yaml
```

## Verify The Result

Observe the actual result. A denied-request command returns a nonzero status when the denial works. Run denial checks separately from a shell sequence that stops on the first nonzero status.

```sh
kubectl -n starfleet rollout status deployment/probe --timeout=180s
kubectl -n starfleet rollout status deployment/probe-canary --timeout=180s
kubectl -n starfleet exec shuttle -- wget -q -T 3 -O- http://probe/
```

Keep three stable version-one replicas and one version-two canary replica. Select both groups with `app: probe, track: shared` through the original Service. Each Deployment must retain its own ownership selector. All four backends must appear ready in EndpointSlices. Do not claim an exact traffic percentage from this replica ratio.

After recording the result, remove this independent lab with `astrona destroy ats-001-lab-010-03-01`.

## Common pitfalls

> [!WARNING]
> Deployment ownership selectors must remain separate. A Service can select both groups, but replica ratios do not guarantee exact request percentages. Count ready endpoints rather than grading a random sample.
