# Wrap-Up: Mission Debrief

Well flown, astronaut. You found a fleet upgrade that never came online and flew the last good design again. Before you move on, look back, check yourself, and clean up the planet `aspen`.

## What you learned

This module was about the rollout history and going back in it.

**From [Build A Rollout History](./course-01-build-a-rollout-history.md):**

- A readiness probe is the pre-flight check the kubelet runs on each container. Until it passes, the pod is not ready.
- A probe on a page that does not exist (`/missing`) keeps the new pods not ready, so the rollout never finishes while the old pods keep running.
- `kubectl rollout history` lists one revision per pod template.
- A rollback needs an earlier revision. On a fresh cluster, apply a working version first.

**From [Roll Back To A Working Revision](./course-02-roll-back-to-a-working-revision.md):**

- Rollback returns the Deployment Pod template to an earlier revision.
- `kubectl rollout undo` goes back one revision; `--to-revision` goes to a chosen one.
- An undo creates a new revision with the old template.
- Prove it with `rollout status`, `get deploy` and the history.

## Your missions

This module has no graded lab yet. Practise the steps on your own cluster with the ideas below.

## Practice on your own

After you solve the task once, repeat it with one or two small changes so the skill becomes flexible:

- Use rollout history --revision.
- Break the image and roll back.
- Compare ReplicaSets before and after undo.

## Exam habits

- Prefer fast imperative commands when they produce the correct object, but switch to YAML when field placement matters.
- Always include `-n <namespace>` for namespaced resources.
- Use `kubectl explain` if you are unsure where a field belongs.
- Verify the live cluster state; do not rely only on the command succeeding.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. A rollout is stuck, but the app still answers. How can that be?</summary>

The new pods fail their readiness probe, so the Deployment controller keeps the old, ready pods running while it waits. The app is fine; the upgrade is stuck.
</details>

<details>
<summary>2. You run <code>kubectl rollout undo</code> on a brand-new Deployment. Why does nothing happen?</summary>

There is only one revision, so there is no earlier template to go back to.
</details>

<details>
<summary>3. When do you use <code>--to-revision</code>?</summary>

When the revision just before the current one is not the working one, for example after two bad updates in a row.
</details>

## Clean up

Remove the module's resources when you are finished:

```bash
kubectl delete namespace aspen
```

> *The fleet order keeps a logbook. When the new design fails its pre-flight check, fly the last good one again.*
