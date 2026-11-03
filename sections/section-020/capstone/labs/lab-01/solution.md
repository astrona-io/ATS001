---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Deployment Rollout Repair And Strategy Capstone Solution

Use a host shell with this lab's private kubeconfig. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool. This environment is separate from the ungraded playground.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-capstone-020)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-capstone-020" || exit 1
```

Keep this connection selected throughout the task. Every script supplied by the lab refuses a different context.

## Inspect And Explain

Read the history of `bridge` first so you know which revision worked. Then fix `scanner` without losing availability checks.

```sh
kubectl -n starfleet rollout history deployment/bridge
kubectl -n starfleet rollout history deployment/bridge --revision=3
kubectl -n starfleet rollout undo deployment/bridge
kubectl -n starfleet rollout status deployment/bridge --timeout=180s
```

The previous revision is revision two, so a plain `undo` is enough here. For `scanner`:

```sh
kubectl -n starfleet patch deployment scanner --type=merge -p '{"spec":{"replicas":3,"strategy":{"type":"Recreate","rollingUpdate":null}}}'
kubectl -n starfleet set env deployment/scanner VERSION=v3
kubectl -n starfleet rollout status deployment/scanner --timeout=180s
```

## Verify The Result

```sh
kubectl -n starfleet exec shuttle -- wget -q -T 3 -O- http://bridge/
kubectl -n starfleet exec shuttle -- wget -q -T 3 -O- http://scanner/
```

## Common pitfalls

> [!WARNING]
> Look at the revision before you undo it. The last revision is the broken one, and the previous revision is the working one. For `scanner`, remove `rollingUpdate` in the same patch that sets `Recreate`.

After recording the result, remove this independent lab with `astrona destroy ats-001-capstone-020`.
