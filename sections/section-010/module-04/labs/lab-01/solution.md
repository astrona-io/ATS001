---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green or canary)
---
# Create A Weighted Canary Ingress Solution

Use a host shell with this lab's private kubeconfig. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool. This environment is separate from the ungraded playground.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-lab-010-04-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-lab-010-04-01" || exit 1
```

Keep this connection selected throughout the task. Every script supplied by the lab refuses a different context.

## Inspect And Explain

The primary Ingress `probe` already routes the host to the stable Service. A canary Ingress is a second Ingress for the same host and path. Its annotations tell the NGINX Ingress controller to send only a share of the matching requests to its own backend.

```sh
kubectl -n starfleet get ingress probe -o yaml
kubectl -n starfleet get service probe probe-canary
```

Save this as `ingress-probe-canary.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: probe-canary
  namespace: starfleet
  annotations:
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-weight: "20"
spec:
  ingressClassName: nginx
  rules:
  - host: probe.starfleet.test
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: probe-canary
            port:
              number: 80
```

Apply it and read it back:

```sh
kubectl apply -f ingress-probe-canary.yaml
kubectl -n starfleet get ingress
kubectl -n starfleet describe ingress probe-canary
```

## Verify The Result

Both Ingress objects now list the same host. Only `probe-canary` carries the canary annotations. Without an Ingress controller the objects do not move any traffic, so the grader reads the fields.

## Common pitfalls

> [!WARNING]
> The canary Ingress must repeat the host and path of the primary Ingress. Annotation values are strings, so the weight is `"20"` in quotes. Do not add the canary annotations to the primary Ingress.

After recording the result, remove this independent lab with `astrona destroy ats-001-lab-010-04-01`.
