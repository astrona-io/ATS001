---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Choosing A Deployment Strategy

A rolling update keeps the application available but runs the old and new versions side by side for a while. Some applications cannot allow that, for example when two versions would write incompatible data to the same volume. The Deployment field `spec.strategy` selects between the two behaviours.

## RollingUpdate And Recreate

The strategy `RollingUpdate` is the default. The Deployment controller creates Pods of the new ReplicaSet and removes Pods of the old one in steps. Two fields limit each step. `maxSurge` is how many Pods above the desired replica count may exist during the update. `maxUnavailable` is how many Pods below the desired count may be unavailable. Each can be a number or a percentage.

The strategy `Recreate` stops all old Pods first and only then creates the new Pods. The application is unavailable between the two moments, and the old and new versions never run together. `Recreate` has no tuning fields, and the API server rejects a Deployment that has `type: Recreate` and a `rollingUpdate` block.

## Percentages And Rounding

A percentage `maxSurge` rounds up. A percentage `maxUnavailable` rounds down. With four replicas and the default 25 percent for both, `maxSurge` is 1 and `maxUnavailable` is 1, so at least three Pods stay available and at most five exist. With two replicas, 25 percent gives a surge of 1 (0.5 rounded up) and an unavailable count of 0 (0.5 rounded down). Both values cannot be 0 at the same time, because the rollout could not make progress, and the API server rejects that.

## Read And Change The Strategy

Select the playground and read the strategy of `relay`.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-playground-020-06)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-020-06"
kubectl -n starfleet get deployment relay -o jsonpath='{.spec.strategy}'
```

The output shows the type and both limits. Change the limits so no Pod is ever unavailable, then update the image tag and wait. The `set image` command changes the image of one container by name, and the Pod template changes, so the rollout starts:

```sh
kubectl -n starfleet patch deployment relay -p '{"spec":{"strategy":{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0}}}}'
kubectl -n starfleet set image deployment/relay probe=docker.io/library/python:3.13-alpine
kubectl -n starfleet rollout status deployment/relay --timeout=120s
```

Because the new image string equals the old one, no template change happens and no rollout starts. Use `set env` to start a real one:

```sh
kubectl -n starfleet set env deployment/relay VERSION=v2
kubectl -n starfleet rollout status deployment/relay --timeout=120s
```

During this rollout the Deployment never drops below two ready Pods, because `maxUnavailable` is 0 and one extra Pod is allowed.

## Scale The Deployment

The command `kubectl scale` changes `spec.replicas` and starts no rollout, because the template is unchanged. Scale to three replicas and read the result:

```sh
kubectl -n starfleet scale deployment relay --replicas=3
kubectl -n starfleet get deployment relay
```

## Switch To Recreate

Changing the type alone fails, because the `rollingUpdate` block remains. Remove the block in the same patch. A merge patch sets a field to null to delete it:

```sh
kubectl -n starfleet patch deployment relay --type=merge -p '{"spec":{"strategy":{"type":"Recreate","rollingUpdate":null}}}'
kubectl -n starfleet set env deployment/relay VERSION=v3
kubectl -n starfleet get pods -l app=relay -w
```

Stop the watch with Ctrl+C after you see the old Pods terminate before new Pods start. You now know the two strategies and how to switch between them. The open question is how to apply several changes without one rollout per change.

## Common pitfalls

> [!WARNING]
> Setting `type: Recreate` while `rollingUpdate` remains is rejected. Both `maxSurge` and `maxUnavailable` set to 0 is also rejected. `kubectl scale` never starts a rollout, so it cannot update a version.
