---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Roll Back To A Named Revision Solution

Use a host shell with this lab's private kubeconfig. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool. This environment is separate from the ungraded playground.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-lab-020-05-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-lab-020-05-01" || exit 1
```

Keep this connection selected throughout the task. Every script supplied by the lab refuses a different context.

## Inspect And Explain

Each change to the Pod template created a new revision, and each revision is stored as a ReplicaSet. List them and compare the Pod templates.

```sh
kubectl -n starfleet rollout history deployment/probe
kubectl -n starfleet rollout history deployment/probe --revision=1
kubectl -n starfleet rollout history deployment/probe --revision=2
kubectl -n starfleet get replicasets
```

Revision one is the working version-one template. A plain `kubectl rollout undo` would go back only one step, to revision two. Name the revision to reach version one.

```sh
kubectl -n starfleet rollout undo deployment/probe --to-revision=1
kubectl -n starfleet rollout status deployment/probe --timeout=180s
kubectl -n starfleet annotate deployment/probe kubernetes.io/change-cause="rolled back to v1" --overwrite
```

## Verify The Result

```sh
kubectl -n starfleet get deployment probe
kubectl -n starfleet exec shuttle -- wget -q -T 3 -O- http://probe/
```

The rollback creates a new revision number that reuses the old template. The history list now shows a fourth revision, not a return to number one.

## Common pitfalls

> [!WARNING]
> `rollout undo` without `--to-revision` goes to the previous revision only. Check the template of the revision with `--revision=N` before you undo. A rollback restores the Pod template and nothing else, so replica count and external data are not restored.

After recording the result, remove this independent lab with `astrona destroy ats-001-lab-020-05-01`.
