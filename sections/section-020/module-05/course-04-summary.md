---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Summary

Every change to the Pod template of a Deployment creates a revision, and each revision is a ReplicaSet that the Deployment keeps with zero replicas. Changes to replicas, the strategy or Deployment annotations create no revision. The field `revisionHistoryLimit` limits how many old revisions remain.

The command `kubectl rollout history` lists revisions, and `--revision=N` shows the template of one. The annotation `kubernetes.io/change-cause` gives each revision a readable reason.

The command `kubectl rollout undo` rolls back to the previous revision, and `--to-revision=N` rolls back to a named one. A rollback is a normal rollout that reuses a stored ReplicaSet and receives a new revision number. It restores the Pod template only, and it does not restore replica counts, external configuration or application data.

<!-- astrona:playground:destroy -->
