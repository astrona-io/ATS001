---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Pausing A Rollout To Batch Changes

Every change to the Pod template starts a rollout. If you need to change the image, an environment variable and a resource limit, three commands would start three rollouts and create three revisions. Pausing the Deployment lets you apply all changes first and start one rollout.

## What Pause Does

`kubectl rollout pause` sets `spec.paused: true`. While the field is true, the Deployment controller still records template changes, but it does not create a new ReplicaSet or roll anything out. Scaling still works, because the replica count is not part of the template. `kubectl rollout resume` sets the field to false, and the controller then starts one rollout for the final template.

A paused Deployment cannot be rolled back, and `rollout undo` reports an error. A paused Deployment also does not count toward the progress deadline, so a paused update never reports a failed progress condition.

## Batch Three Changes

Select the playground and pause `relay`.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-playground-020-06)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-020-06"
kubectl -n starfleet rollout pause deployment/relay
kubectl -n starfleet get deployment relay -o jsonpath='{.spec.paused}'
```

The second command prints `true`. Apply two template changes and read the history:

```sh
kubectl -n starfleet set env deployment/relay VERSION=v4
kubectl -n starfleet set resources deployment/relay --limits=memory=192Mi
kubectl -n starfleet rollout history deployment/relay
```

No new revision exists yet, and the Pods are unchanged. Check the rollout state, then resume:

```sh
kubectl -n starfleet rollout status deployment/relay --timeout=10s
kubectl -n starfleet rollout resume deployment/relay
kubectl -n starfleet rollout status deployment/relay --timeout=120s
kubectl -n starfleet rollout history deployment/relay
```

While the Deployment is paused, the `status` command reports the paused state or waits, and the short timeout ends it. After the resume, one rollout applies both changes, and the history shows one new revision.

## Restart Without A Change

The command `kubectl rollout restart deployment/relay` rolls all Pods without a visible template change. It adds an annotation with the restart time to the Pod template, which creates a new revision. Use it to make Pods read a changed ConfigMap value, or to replace Pods after a fix outside the template. It follows the strategy, so a `Recreate` Deployment is briefly unavailable.

## Deciding Between The Tools

Use a rolling update when two versions can run together and availability matters. Use `Recreate` when they cannot. Use pause when several edits belong together. A common exam pattern combines them: pause, apply changes, resume, then check the rollout and the history.

## Common pitfalls

> [!WARNING]
> A forgotten paused Deployment ignores later template edits without any error. Always read `spec.paused` when a change seems to do nothing. Resume before you try `rollout undo`.
