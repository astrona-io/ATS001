---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Recording And Reading Revision History

When a release goes wrong, the first question is what changed. A Deployment answers that question by keeping one record for every version of its Pod template. This part shows where the records live and how to read them.

## Revisions Are ReplicaSets

A Deployment does not run Pods itself. It owns ReplicaSets, and each ReplicaSet runs the Pods of one Pod template. When you change `spec.template`, the Deployment controller creates a new ReplicaSet for the new template, scales it up, and scales the old ReplicaSet down. The old ReplicaSet stays, with zero replicas, as a stored revision.

Only changes to `spec.template` create a revision. Changing the image, an environment variable, a label inside the template or a probe does. Changing `spec.replicas`, the strategy or an annotation on the Deployment does not. The Deployment writes the revision number into the annotation `deployment.kubernetes.io/revision`. The field `spec.revisionHistoryLimit` sets how many old ReplicaSets are kept, and the default is 10.

## Read The History

Select the playground cluster and list the history of the `probe` Deployment.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-playground-020-05)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-playground-020-05"
kubectl -n starfleet rollout history deployment/probe
```

The command lists the revisions with a column named `CHANGE-CAUSE`. A fresh Deployment has one revision, and the cause is empty. Create a second revision by changing an environment variable in the template, and wait for it:

```sh
kubectl -n starfleet set env deployment/probe VERSION=v2
kubectl -n starfleet rollout status deployment/probe --timeout=120s
kubectl -n starfleet rollout history deployment/probe
```

The history now has two revisions. The ReplicaSets show the same two records, where the old one has zero replicas:

```sh
kubectl -n starfleet get replicasets -l app=probe
```

## Look Inside One Revision

The `--revision` flag prints the Pod template of one revision. Compare the two:

```sh
kubectl -n starfleet rollout history deployment/probe --revision=1
kubectl -n starfleet rollout history deployment/probe --revision=2
```

Revision one lists `VERSION` as `v1` and revision two lists `v2`. This is the evidence you need before you roll back.

## Record Why A Change Happened

The `CHANGE-CAUSE` column reads the annotation `kubernetes.io/change-cause` of the ReplicaSet. The Deployment copies that annotation from itself when it creates a ReplicaSet. The old `--record` flag filled it with the command line, but the flag is deprecated. Set the annotation yourself:

```sh
kubectl -n starfleet annotate deployment/probe kubernetes.io/change-cause="set VERSION to v2" --overwrite
kubectl -n starfleet rollout history deployment/probe
```

The annotation is copied to the ReplicaSet of the current revision, so the second revision shows your text. Set the annotation right after each change, so the history explains itself. You can now read what each revision contains and why it exists, and the open question is how to return to one.

## Common pitfalls

> [!WARNING]
> Scaling does not create a revision, so the history cannot restore a replica count. A change-cause annotation set before a template change describes the previous revision, not the next one. A low `revisionHistoryLimit` removes old revisions that you may need.
