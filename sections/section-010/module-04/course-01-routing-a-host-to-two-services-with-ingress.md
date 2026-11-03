---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green
  or canary)
---
# Routing A Host To Two Services With Ingress

A Service gives Pods one stable address inside the cluster. Clients outside the cluster, and rules based on host names or URL paths, need another object. That object is the Ingress, and this part shows what it declares, which component acts on it, and how to create one.

## What An Ingress Is

An Ingress is an API object in the group `networking.k8s.io/v1`. It holds rules that map an HTTP host name and a URL path to a backend Service and port. The Ingress itself does nothing. An Ingress controller, a program that runs in the cluster, watches Ingress objects and configures a reverse proxy to follow them. NGINX Ingress is one such controller.

The field `spec.ingressClassName` names the IngressClass that selects the controller. Each rule has an optional `host`, and each path has a `pathType`: `Exact` matches only the given path, and `Prefix` matches the path and everything below it. The backend names a Service and a port, either by number or by port name.

## Create An Ingress From The Command Line

The `kubectl create ingress` command builds the object from a rule string. The `--dry-run=client -o yaml` flags print it without creating it. Select the playground first.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-playground-010-04)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-010-04"
kubectl -n starfleet create ingress probe --class=nginx --rule="probe.starfleet.test/*=probe:80" --dry-run=client -o yaml
```

The rule `host/path=service:port` has a trailing `*`, which produces `pathType: Prefix`. The printed object has one rule for the host `probe.starfleet.test` and the backend Service `probe` on port 80. Save the same object as a file and apply it, so you can edit it later.

Save this as `ingress-probe.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: probe
  namespace: starfleet
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
            name: probe
            port:
              number: 80
```

Apply it:

```sh
kubectl apply -f ingress-probe.yaml
```

Then check the result:

```sh
kubectl -n starfleet get ingress probe
kubectl -n starfleet describe ingress probe
```

The API server accepts the object even though no controller exists in this cluster. The `describe` output lists the rule and the backend. The address column stays empty, because only a controller can assign an address.

## Why A Second Ingress Matters

Two Ingress objects can name the same host and path only when a controller defines how to combine them. Without special handling, two such objects conflict, and the controller picks one. Controllers such as NGINX Ingress give the second object a defined meaning through a canary annotation. You now know how a single Ingress maps a host and path to a Service, and the open question is how a second Service shares that same host.

## Common pitfalls

> [!WARNING]
> An Ingress object without a controller routes nothing, and kubectl shows no error. Check that an IngressClass and a controller exist before you debug the rules. A `Prefix` path of `/` matches everything, so it hides more specific paths of other Ingress objects that the controller sorts lower.
