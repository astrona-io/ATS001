---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Rolling Back To A Chosen Revision

A rollback is a rollout whose new Pod template is an old one. Because it is a normal rollout, it follows the same strategy rules and creates a new revision number. This part shows the two forms of the command and the limits of a rollback.

## Undo The Last Change

The command `kubectl rollout undo` tells the Deployment controller to take the Pod template of the previous revision and roll it out again. The controller finds the ReplicaSet that already holds that template, scales it up, and scales the current ReplicaSet down. It copies no template: it reuses the stored ReplicaSet.

The playground has two revisions after the previous steps. Undo the last change and read the result:

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-playground-020-05)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-020-05"
kubectl -n starfleet rollout undo deployment/probe
kubectl -n starfleet rollout status deployment/probe --timeout=120s
kubectl -n starfleet rollout history deployment/probe
```

If you start this part with a fresh playground, run `kubectl -n starfleet set env deployment/probe VERSION=v2` first so that a second revision exists. After the undo, the history does not return to the old number. The reused template receives a new, higher revision number, and the old number disappears from the list, because one ReplicaSet holds one template.

## Go To A Named Revision

When the previous revision is also broken, name the target. Create a third and fourth revision, then go back to the first:

```sh
kubectl -n starfleet set env deployment/probe VERSION=v3
kubectl -n starfleet rollout status deployment/probe --timeout=120s
kubectl -n starfleet set env deployment/probe VERSION=v4
kubectl -n starfleet rollout status deployment/probe --timeout=120s
kubectl -n starfleet rollout history deployment/probe
```

Pick the revision whose template you want from the list and check it with `--revision=N`. Then undo to it:

```sh
kubectl -n starfleet rollout undo deployment/probe --to-revision=1
kubectl -n starfleet rollout status deployment/probe --timeout=120s
kubectl -n starfleet get deployment probe -o jsonpath='{.spec.template.spec.containers[0].env}'
```

The environment variable is `v1` again. Request the application through the client Pod to confirm the version:

```sh
kubectl -n starfleet exec shuttle -- wget -q -T 3 -O- http://probe/
```

## What A Rollback Does Not Restore

A rollback restores only `spec.template`. The replica count, the strategy, the Service and the data your application wrote stay as they are. External changes, for example a ConfigMap you edited or a database migration, are not part of the history. Use `kubectl rollout restart` when you want a new rollout of the same template: it adds a restart annotation to the template, which creates a new revision with a new ReplicaSet.

A rollback also needs the old ReplicaSet to exist. If `revisionHistoryLimit` removed it, the command reports that the revision was not found. You now know both rollback forms and their limits. The remaining skill is to choose between rolling back and fixing forward, which depends on how fast the fix is and what the failed revision changed outside the template.

## Common pitfalls

> [!WARNING]
> `rollout undo` without `--to-revision` goes back one step only. Undoing twice returns to the failed revision, because the second undo goes back to the revision you just left. Check the template with `--revision=N` before you undo.
