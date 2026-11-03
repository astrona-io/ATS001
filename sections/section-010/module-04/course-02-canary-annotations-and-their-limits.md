---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green
  or canary)
---
# Canary Annotations And Their Limits

The core Ingress API has no field for a traffic share. Controllers add that feature through annotations, which are key and value pairs in the object metadata. This part uses the NGINX Ingress annotations to describe a weighted canary and explains which parts depend on the controller.

## The Canary Ingress

A canary setup has two Ingress objects for the same host and path. The primary Ingress is normal and points to the stable Service. The canary Ingress points to the canary Service and carries these annotations:

- `nginx.ingress.kubernetes.io/canary: "true"` marks the object as a canary of the primary Ingress.
- `nginx.ingress.kubernetes.io/canary-weight: "20"` sends 20 percent of the requests to the canary Service.
- `nginx.ingress.kubernetes.io/canary-by-header: "X-Canary"` sends a request to the canary when that header equals `always`, and never when it equals `never`.

Annotation values are strings, so numbers need quotes. The weight is a number from 0 to 100, and the default total is 100. When a request carries the canary header, the header rule wins over the weight. The controller matches the canary object to the primary object by host and path, so both must repeat the same values.

## Save And Apply The Canary

The playground has the stable Service `probe` and the canary Service `probe-canary`. A canary only works beside a primary Ingress with the same host and path.

<!-- astrona:playground:renew -->

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

Apply it:

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-playground-010-04)"
kubectl apply -f ingress-probe-canary.yaml
```

Then check the result:

```sh
kubectl -n starfleet get ingress
kubectl -n starfleet get ingress probe-canary -o jsonpath='{.metadata.annotations}'
```

The listing shows two Ingress objects with the same host. The annotation output shows the two canary keys.

## What Depends On The Controller

The core API validates only the standard fields. A misspelled annotation key is accepted and silently ignored. The weight is a probabilistic split per request, so it needs many requests to approach 20 percent. A Service-based canary shares traffic by endpoint count and can be changed with replica counts. An Ingress canary shares by request and can be changed with one annotation, and it leaves the replica counts alone. Other controllers use other annotations or other objects, so the NGINX keys do not carry over.

You can now describe the full canary: two Services, two Ingress objects and three annotations. The remaining skill is to build it from a given starting state and to decide when to promote it, which the lab and the practice cover.

## Common pitfalls

> [!WARNING]
> Annotations are not validated, so a typo makes the canary an ordinary second Ingress. Quote the weight as a string. Do not put the canary annotations on the primary Ingress, and repeat the host and path exactly on both objects.
