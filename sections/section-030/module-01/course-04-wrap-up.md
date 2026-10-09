# Wrap-Up: Mission Debrief

Well flown, astronaut. You called one scout group back and sent another out at exactly the size you wanted. Before you move on, look back, check yourself, and clean up both planets.

## What you learned

This module was about shaping a canary with pod counts and keeping those counts per environment with Kustomize.

**From [Canary Traffic By Pod Count](./course-01-canary-traffic-by-pod-count.md):**

- Canary percentage can be approximated by selected Pod counts when Pods are equivalent endpoints.
- 20 percent of 10 pods is 2 canary and 8 stable pods, with a Service that selects both tracks.
- For 0 percent, scale the canary to 0 or narrow the selector to the stable track, or both.

**From [Roll Back A Canary With An Overlay](./course-02-roll-back-a-canary-with-an-overlay.md):**

- A base holds the full objects; an overlay points at the base and adds patches.
- A patch is a partial object, matched by kind, name and namespace, and merged in.
- `kubectl kustomize <overlay>` renders the result; `kubectl apply -k <overlay>` applies it.

**From [A Twenty Percent Canary](./course-03-a-twenty-percent-canary.md):**

- The same layout reaches a different target by changing only the patch.
- Both replica counts set the share, and the selector must use only the shared label.

## Your missions

This module has no graded lab yet. Practise the steps on your own cluster with the ideas below.

## Practice on your own

After you solve the task once, repeat it with one or two small changes so the skill becomes flexible:

- Change tea-two to 50 percent canary.
- Use kubectl diff -k before apply.
- Move common labels into the base.

## Exam habits

- Prefer fast imperative commands when they produce the correct object, but switch to YAML when field placement matters.
- Always include `-n <namespace>` for namespaced resources.
- Use `kubectl explain` if you are unsure where a field belongs.
- Verify the live cluster state; do not rely only on the command succeeding.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. You need a 25 percent canary with 8 pods in total. How many of each?</summary>

2 canary pods and 6 stable pods, with a Service selector that uses only the shared `app` label.
</details>

<details>
<summary>2. The canary has 2 replicas, but it gets no traffic. What do you check?</summary>

The Service selector. If it names `track: stable`, the canary pods never match, whatever their count.
</details>

<details>
<summary>3. What is the difference between <code>kubectl kustomize</code> and <code>kubectl apply -k</code>?</summary>

`kubectl kustomize` only prints the combined base and overlay. `kubectl apply -k` builds the same result and sends it to the cluster.
</details>

## Clean up

Remove the module's resources when you are finished:

```bash
kubectl delete namespace tea-one tea-two
```

> *A small scout group first. Its share of the fleet is its share of the signals.*
