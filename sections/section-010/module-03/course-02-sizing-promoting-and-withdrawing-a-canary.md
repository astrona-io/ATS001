---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green
  or canary)
---
# Sizing, Promoting And Withdrawing A Canary

A canary release is only useful when you control how large it is and how it ends. You must choose how many replicas the canary gets, decide what evidence allows promotion, and know the exact commands that remove the canary again. This part covers those three decisions with ordinary Deployments and Services.

## Sizing The Canary With Replica Counts

A Service that selects the shared label `app: probe` sends new connections to every ready Pod that carries it. With four stable replicas and one canary replica, five endpoints are ready, and the canary is one of them. The expected share of new connections is about one in five, which is 20 percent. This is an estimate from endpoint counts, not a guarantee, because clients that keep a connection open stay on the Pod they first reached.

To change the share, change the number of replicas of either Deployment. The `kubectl scale` command sets the replica count of a Deployment directly. Two canary replicas beside four stable replicas give about one in three. Remember that a smaller share needs more stable replicas: a 5 percent canary needs about 19 stable replicas for each canary replica, so Service-based canaries suit coarse shares.

## Stable And Canary Must Own Different Pods

Each Deployment needs a selector that only matches its own Pods. Both Deployments add the shared label `app: probe` for the Service. They also add a label that differs, such as `release: probe` and `release: probe-canary`. If both Deployments selected only `app: probe`, each controller would count the other's Pods as its own, and the replica counts would fight. The Service selector uses only the shared label, and each Deployment selector uses the shared label plus its own `release` label.

## Scale And Count Endpoints

The playground has the stable Deployment `probe` with two replicas. Scale it up and watch the endpoint count follow.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-playground-010-03)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-010-03"
kubectl -n starfleet scale deployment probe --replicas=4
kubectl -n starfleet rollout status deployment/probe --timeout=120s
```

The `scale` command changes only `spec.replicas`. The Deployment controller creates two more Pods, and `rollout status` waits until they are ready. Now count the ready endpoints of the Service:

```sh
kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=probe -o jsonpath='{range .items[*].endpoints[*]}{.conditions.ready}{"\n"}{end}'
```

The command prints one line per endpoint. Four lines that read `true` mean four ready backends. Return the Deployment to its starting size:

```sh
kubectl -n starfleet scale deployment probe --replicas=2
```

## Promotion And Withdrawal

Promotion means the new version becomes the only version. With two Deployments, promote in this order. First update the stable Deployment to the new template, so its Pods roll to the new version under the rolling update rules. Wait until its rollout is complete. Then scale the canary Deployment to zero or delete it. Never remove the canary first, because the exposed share would fall to zero before the stable Pods are ready.

You can preview the template change without applying it. The `--dry-run=client` flag prints the modified object and sends nothing to the cluster:

```sh
kubectl -n starfleet set env deployment/probe VERSION=v2 --dry-run=client -o yaml
```

Withdrawal means the canary failed and must stop receiving traffic. The fastest withdrawal is `kubectl scale deployment probe-canary --replicas=0`, which removes the canary endpoints and keeps the Deployment for inspection. A second way is to narrow the Service selector back to `release: probe`, which keeps the canary Pods running but unreachable through the Service. Choose the second way when you still want to test the Pods directly.

Evidence for the decision must come from the canary version itself. An overall error rate that mixes both versions can hide a failing canary when the canary carries only 20 percent of the traffic. You now know how to size, promote and withdraw a canary with Services only. The remaining limit is precision: a Service cannot send an exact 5 percent, which is why an Ingress controller with weights is often used.

## Common pitfalls

> [!WARNING]
> Do not give the canary Deployment a selector that also matches the stable Pods. Do not promote by deleting the canary before the stable Deployment has finished its rollout. Scale the stable Deployment back to its original size when you finish a practice, because later exercises assume two replicas.
