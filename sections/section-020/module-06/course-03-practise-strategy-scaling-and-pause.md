---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Practise Strategy, Scaling And Pause

The `relay` Deployment in `starfleet` must grow to four replicas and move to version five without any Pod becoming unavailable. This exercise sets the limits, scales, and applies the update as a single rollout.

<!-- astrona:playground:renew -->

Select the playground and read the starting state:

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-playground-020-06)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-020-06"
kubectl -n starfleet get deployment relay -o jsonpath='{.spec.replicas} {.spec.strategy}'
```

Pause the Deployment, then apply the limit change, the scale and the new version:

```sh
kubectl -n starfleet rollout pause deployment/relay
kubectl -n starfleet patch deployment relay -p '{"spec":{"replicas":4,"strategy":{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0}}}}'
kubectl -n starfleet set env deployment/relay VERSION=v5
kubectl -n starfleet get pods -l app=relay
```

The scale takes effect at once, so four Pods run the old version, and the new version has not started. Resume and watch the rollout:

```sh
kubectl -n starfleet rollout resume deployment/relay
kubectl -n starfleet rollout status deployment/relay --timeout=180s
kubectl -n starfleet get replicasets -l app=relay
```

The ReplicaSet of the new version has four Pods and the old one has zero. Confirm the version with a request, then change the strategy to Recreate and trigger a restart:

```sh
kubectl -n starfleet exec shuttle -- wget -q -T 3 -O- http://relay/
kubectl -n starfleet patch deployment relay --type=merge -p '{"spec":{"strategy":{"type":"Recreate","rollingUpdate":null}}}'
kubectl -n starfleet rollout restart deployment/relay
kubectl -n starfleet rollout status deployment/relay --timeout=180s
```

All old Pods end before the new Pods start, so the Service has no backend for a short time.

## Common pitfalls

> [!WARNING]
> Do not run `rollout restart` on a paused Deployment: kubectl refuses and asks you to resume first. Remove `rollingUpdate` in the same patch that sets `Recreate`.
