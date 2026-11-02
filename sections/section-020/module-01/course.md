# Roll Out A New Version Without Downtime

Astronaut, a fleet that carries passengers cannot all land at once for an upgrade. You swap the ships a few at a time, and the sky is never empty. In Kubernetes, a Deployment does that swap for you. It is called a rolling update, and you decide how fast it goes.

Remember this sentence for the CKAD exam:

> A Deployment rollout changes Pods only when the Pod template changes.

## Learning objectives

After this module you can:

- Explain which change to a Deployment starts a rollout, and which does not.
- Explain what `maxSurge` and `maxUnavailable` mean, and work out how many pods can exist during a rollout.
- Set a Deployment's rolling update strategy with `kubectl patch`.
- Start a rollout with `kubectl set env`, and follow it with `kubectl rollout status`.
- Prove the result with JSONPath, ReplicaSets and the rollout history.

## Before you start

You need a practice Kubernetes cluster and `kubectl` set up to talk to it. Any small cluster works, for example one made with `kind create cluster`. You should know that a pod is one running copy of an app (a spaceship), and that a Deployment keeps a set number of pods running (the fleet order).

The module works on the planet (namespace) `mercury`, with one Deployment called `cassini`. You create both in the first part, and delete them at the end.

## The parts of this module

Read the parts in this order. Each one takes about 5 to 10 minutes.

| Part | What you learn |
| --- | --- |
| [What Starts A Rollout](./course-01-what-starts-a-rollout.md) | The pod template, ReplicaSets and rollout history, on a live Deployment |
| [Roll Out With Zero Downtime](./course-02-roll-out-with-zero-downtime.md) | `maxSurge` and `maxUnavailable`, setting the strategy, starting the rollout and proving it |
| [Wrap-Up: Mission Debrief](./course-03-wrap-up.md) | What you learned, exam habits, practice ideas and cleaning up |

## Why this matters

On the exam, and at work, "update the app with zero downtime" is a common task. If you change the wrong field, nothing rolls out, or the app goes briefly offline. Knowing exactly which field starts a rollout, and which fields set its pace, turns this into a two-command task.
