# Shape A Canary With Kustomize Overlays

Astronaut, before a whole fleet switches to a new ship design, you send a small scout group of new ships to fly with the old ones. If the scouts do well, more follow; if not, you call them back. That is a canary deployment. Kustomize helps you keep the size of the scout group per environment, without copying your files.

Remember this sentence for the CKAD exam:

> Canary percentage can be approximated by selected Pod counts when Pods are equivalent endpoints.

## Learning objectives

After this module you can:

- Work out how many stable and canary pods give a target share of traffic.
- Explain two ways to send 0% of traffic to a canary.
- Explain what a Kustomize base, an overlay and a patch are.
- Render an overlay with `kubectl kustomize` before you apply it, and apply it with `kubectl apply -k`.
- Prove the result from replica counts, pod labels and the Service selector.

## Before you start

You need a practice Kubernetes cluster and `kubectl` set up to talk to it, for example one made with `kind create cluster`. Kustomize is built into `kubectl`, so you need nothing else. You should know that a Service sends traffic to the pods whose labels match its selector.

The module works on two planets (namespaces), `tea-one` and `tea-two`. Each has a stable Deployment `tea`, a canary Deployment `tea-canary` and a Service `tea`. You build both from files you save in the parts, and delete them at the end.

## The parts of this module

Read the parts in this order. Each one takes about 5 to 10 minutes.

| Part | What you learn |
| --- | --- |
| [Canary Traffic By Pod Count](./course-01-canary-traffic-by-pod-count.md) | How pod counts and the Service selector set the canary's share of traffic |
| [Roll Back A Canary With An Overlay](./course-02-roll-back-a-canary-with-an-overlay.md) | A Kustomize base and a prod overlay for `tea-one`: 4 pods, 0% canary |
| [A Twenty Percent Canary](./course-03-a-twenty-percent-canary.md) | The same tree for `tea-two`: 10 pods, 20% canary |
| [Wrap-Up: Mission Debrief](./course-04-wrap-up.md) | What you learned, exam habits, practice ideas and cleaning up |

## Why this matters

Kubernetes has no built-in "send 20% here" switch for plain Services. On the exam you shape a canary with the tools you have: replica counts, labels and a Service selector. Kustomize is the exam's tool for keeping those numbers per environment, so you change one small patch, not a copy of every file.
