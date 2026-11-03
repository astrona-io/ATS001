---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Switch To Recreate And Scale With One Rollout Solution

Use a host shell with this lab's private kubeconfig. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool. This environment is separate from the ungraded playground.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-lab-020-06-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-lab-020-06-01" || exit 1
```

Keep this connection selected throughout the task. Every script supplied by the lab refuses a different context.

## Inspect And Explain

A Deployment with strategy `Recreate` cannot carry `rollingUpdate` settings, so the patch must remove them. Pausing first lets you make all three changes and start one rollout.

```sh
kubectl -n starfleet get deployment relay -o yaml
kubectl -n starfleet rollout pause deployment/relay
kubectl -n starfleet patch deployment relay --type=merge -p '{"spec":{"replicas":3,"strategy":{"type":"Recreate","rollingUpdate":null}}}'
kubectl -n starfleet set env deployment/relay VERSION=v2
kubectl -n starfleet rollout resume deployment/relay
kubectl -n starfleet rollout status deployment/relay --timeout=180s
```

## Verify The Result

```sh
kubectl -n starfleet get deployment relay -o jsonpath='{.spec.strategy}'
kubectl -n starfleet exec shuttle -- wget -q -T 3 -O- http://relay/
```

## Common pitfalls

> [!WARNING]
> Changing only `type` to `Recreate` is rejected while `rollingUpdate` settings remain. Set `rollingUpdate` to `null` in the same patch. A paused Deployment applies no template changes until you run `rollout resume`.

After recording the result, remove this independent lab with `astrona destroy ats-001-lab-020-06-01`.
