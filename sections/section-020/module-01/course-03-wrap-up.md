# Wrap-Up: Mission Debrief

Well flown, astronaut. You swapped a whole fleet without ever leaving the sky short of ships. Before you move on, look back, check yourself, and clean up the planet `mercury`.

## What you learned

This module was about what starts a rollout and what sets its pace.

**From [What Starts A Rollout](./course-01-what-starts-a-rollout.md):**

- A Deployment rollout changes Pods only when the Pod template changes.
- Each version of the pod template gets its own ReplicaSet. The Deployment controller scales the new one up and the old one down.
- Changing `spec.strategy` alone creates no new ReplicaSet.
- `kubectl rollout history` lists one revision per pod template.
- Read a task in five steps: namespace, object type, which part of the object, smallest change, verify.

**From [Roll Out With Zero Downtime](./course-02-roll-out-with-zero-downtime.md):**

- `maxSurge` is how many extra pods may exist during a rollout; `maxUnavailable` is how many desired pods may be unavailable.
- With `replicas: 4`, `maxSurge: 2` allows up to 6 pods, and `maxUnavailable: 0` keeps at least 4 ready.
- Set the strategy with `kubectl patch`, then start the rollout with a pod template change such as `kubectl set env`.
- Prove it with JSONPath on `.spec.strategy` and the container `env`, and with `rollout history`.

## Your missions

This module has no graded lab yet. Practise the steps on your own cluster with the ideas below.

## Practice on your own

After you solve the task once, repeat it with one or two small changes so the skill becomes flexible:

- Set maxSurge as a percentage.
- Use rollout pause and resume.
- Inspect ReplicaSets during the rollout.

## Exam habits

- Prefer fast imperative commands when they produce the correct object, but switch to YAML when field placement matters.
- Always include `-n <namespace>` for namespaced resources.
- Use `kubectl explain` if you are unsure where a field belongs.
- Verify the live cluster state; do not rely only on the command succeeding.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. You patch only <code>maxSurge</code> on a Deployment. Do new pods start?</summary>

No. The strategy is outside the pod template, so no new ReplicaSet is created. The new pace is used the next time the pod template changes.
</details>

<details>
<summary>2. A Deployment has <code>replicas: 4</code>, <code>maxSurge: 2</code> and <code>maxUnavailable: 0</code>. What is the most pods that can exist during a rollout, and the fewest ready ones?</summary>

At most 6 pods (4 plus 2 extra), and never fewer than 4 ready pods.
</details>

<details>
<summary>3. Why does <code>kubectl set env</code> start a rollout?</summary>

It changes the container's environment variables inside `spec.template`, the pod template. Any pod template change makes the Deployment controller build a new ReplicaSet.
</details>

## Clean up

Remove the module's resources when you are finished:

```bash
kubectl delete namespace mercury
```

> *Change the ship design, and the fleet is swapped. Set the surge and the unavailable count, and you decide how fast.*
