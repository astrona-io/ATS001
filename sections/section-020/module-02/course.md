# Roll Back A Broken Rollout

Astronaut, sometimes the new ships never pass their pre-flight check. The fleet order keeps waiting for them, and the upgrade never finishes. A Deployment keeps a logbook of every ship design it has flown, so you can go back to one that worked.

Remember this sentence for the CKAD exam:

> Rollback returns the Deployment Pod template to an earlier revision.

## Learning objectives

After this module you can:

- Explain what a readiness probe is, and why a failing one stops a rollout.
- Build a rollout history and read it with `kubectl rollout history`.
- Roll back to the previous revision with `kubectl rollout undo`, or to a chosen one with `--to-revision`.
- Prove the rollback with `kubectl rollout status` and the history.

## Before you start

You need a practice Kubernetes cluster and `kubectl` set up to talk to it, for example one made with `kind create cluster`. You should know that a Deployment keeps a set number of pods running, and that each change to its pod template (the ship design inside the fleet order) starts a rollout with a new ReplicaSet.

The module works on the planet (namespace) `aspen`, with one Deployment called `api-new-c32`. You create both in the first part, and delete them at the end.

## The parts of this module

Read the parts in this order. Each one takes about 5 to 10 minutes.

| Part | What you learn |
| --- | --- |
| [Build A Rollout History](./course-01-build-a-rollout-history.md) | Readiness probes, a working revision and a broken one, and reading the history |
| [Roll Back To A Working Revision](./course-02-roll-back-to-a-working-revision.md) | `kubectl rollout undo`, `--to-revision`, and proving the result |
| [Wrap-Up: Mission Debrief](./course-03-wrap-up.md) | What you learned, exam habits, practice ideas and cleaning up |

## Why this matters

A broken rollout does not always crash anything. The old pods may keep running while the new ones never become ready, so the app looks fine and the upgrade quietly never finishes. On the exam, a task like "a recent update never came online" expects you to read the history and roll back in a minute or two.
