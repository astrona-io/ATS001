---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green
  or canary)
---
# Switch A Service To A Ready Deployment Solution

Use a host shell with this lab's private kubeconfig. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool. This environment is separate from the ungraded playground.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-lab-010-02-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-lab-010-02-01" || exit 1
```

Keep this connection selected throughout the task. Every script supplied by the lab refuses a different context.

## Inspect And Explain

The application and client fixtures are healthy. Complete the required change without replacing unrelated resources.

Inspect the relevant evidence:

```sh
kubectl -n starfleet get pods
kubectl -n starfleet get deployment probe -o yaml
```

A Service forwards to ready Pods matching its selector. Creating a second Deployment lets you verify the new version before changing that selector. The previous Deployment remains available for a deliberate reversal.


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
      release: green
  template:
    metadata:
      labels:
        app: probe
        release: green
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
    release: green
  ports:
  - name: http
    port: 80
    targetPort: http
```

Apply the required change:

```sh
kubectl apply -f deployment-probe-green.yaml
```

## Verify The Result

Observe the actual result. A denied-request command returns a nonzero status when the denial works. Run denial checks separately from a shell sequence that stops on the first nonzero status.

```sh
kubectl -n starfleet rollout status deployment/probe-green --timeout=180s
kubectl -n starfleet exec shuttle -- wget -q -T 3 -O- http://probe/
```

Create Deployment `probe-green` with two replicas running version `v2`, label `release: green` and the existing application command. Change only the `probe` Service selector to `app: probe, release: green`. Keep TCP port 80 and target port `http`. Preserve the original `probe` Deployment. The original client must receive version two.

After recording the result, remove this independent lab with `astrona destroy ats-001-lab-010-02-01`.

## Common pitfalls

> [!WARNING]
> Change the Service only after the new Deployment becomes ready. Changing Deployment ownership labels can break its selector contract. Keep the previous version available for recovery.
