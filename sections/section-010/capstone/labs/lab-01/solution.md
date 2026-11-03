---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green or canary)
---
# Blue-Green And Canary Release Capstone Solution

Use a host shell with this lab's private kubeconfig. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool. This environment is separate from the ungraded playground.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-capstone-010)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-capstone-010" || exit 1
```

Keep this connection selected throughout the task. Every script supplied by the lab refuses a different context.

## Inspect And Explain

Two strategies are needed. For `probe`, a prepared second Deployment and a selector change switch every new connection at once (blue-green). For `relay`, a one-replica Deployment with the shared `app: relay` label joins the existing Service, so about one request in four can reach it (canary).

```sh
kubectl -n starfleet get deployments,services
kubectl -n starfleet get deployment probe -o yaml
```

Save the two Deployments (copy the existing `probe` template and change the name, labels, `VERSION` and replicas) as `deployment-probe-green.yaml` and `deployment-relay-canary.yaml`. Then run:

```sh
kubectl apply -f deployment-probe-green.yaml
kubectl apply -f deployment-relay-canary.yaml
kubectl -n starfleet rollout status deployment/probe-green --timeout=180s
kubectl -n starfleet rollout status deployment/relay-canary --timeout=180s
kubectl -n starfleet set selector service probe app=probe,release=probe-green
```

## Verify The Result

```sh
kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=relay
kubectl -n starfleet exec shuttle -- wget -q -T 3 -O- http://probe/
```

The request to `probe` should report version v2 from a `probe-green` Pod. The `relay` Service should list four ready endpoints.

## Common pitfalls

> [!WARNING]
> Switch the `probe` selector only after `probe-green` is ready. Give `relay-canary` its own `release` label so its Deployment does not take over the stable Pods, and keep the shared `app: relay` label so the Service selects it.

After recording the result, remove this independent lab with `astrona destroy ats-001-capstone-010`.
