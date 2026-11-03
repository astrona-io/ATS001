---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green
  or canary)
---
# Practise Canary Ingress Objects

You have the stable and canary Services in the playground. This exercise builds the primary and canary Ingress objects, changes the weight, adds a header rule and removes the canary again. Because no controller is installed, you check the stored objects, not the traffic split.

The scenario is that the `probe` application in `starfleet` gets version two, and the team wants one request in five to reach it first.

<!-- astrona:playground:renew -->

Select the playground cluster and look at the Services:

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-playground-010-04)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-010-04"
kubectl -n starfleet get services probe probe-canary
kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=probe-canary
```

Both Services have ready endpoints. Create the primary Ingress with the command line and the canary Ingress with the `--annotation` flag of the same command:

```sh
kubectl -n starfleet create ingress probe --class=nginx --rule="probe.starfleet.test/*=probe:80"
kubectl -n starfleet create ingress probe-canary --class=nginx --rule="probe.starfleet.test/*=probe-canary:80" --annotation nginx.ingress.kubernetes.io/canary=true --annotation nginx.ingress.kubernetes.io/canary-weight=20
kubectl -n starfleet get ingress
```

Change the weight with `kubectl annotate`. The `--overwrite` flag replaces an existing key. Add the header rule in the same command:

```sh
kubectl -n starfleet annotate ingress probe-canary nginx.ingress.kubernetes.io/canary-weight=50 nginx.ingress.kubernetes.io/canary-by-header=X-Canary --overwrite
kubectl -n starfleet get ingress probe-canary -o jsonpath='{.metadata.annotations}'
```

The output shows the weight 50 and the header key. Withdraw the canary by deleting its Ingress, which leaves the stable path untouched:

```sh
kubectl -n starfleet delete ingress probe-canary
kubectl -n starfleet get ingress
```

Only the primary Ingress remains. Promotion works in the opposite direction: update the stable Deployment, wait for its rollout, then delete the canary Ingress and its Deployment. A real controller would send the requests as the annotations describe, and you would measure them with the response version, as the earlier Service canary did.

## Common pitfalls

> [!WARNING]
> `kubectl annotate` refuses to change an existing key without `--overwrite`. Deleting the primary Ingress while the canary exists leaves the canary without a primary, and the controller then ignores the canary marking.
