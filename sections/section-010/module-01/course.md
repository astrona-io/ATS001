# Switch Traffic Between Two Versions

Astronaut, imagine two whole fleets of the same ship design in flight: the blue fleet and the green fleet. One beacon calls them, and you decide which fleet answers. That is blue-green deployment, and in Kubernetes the beacon is a Service.

Blue-green deployment keeps two versions of an app available at the same time:

- **blue** is the version that should get user traffic.
- **green** is the other version, often a new release you are checking, or a fallback.

Switching between them is one small change: you change which pod labels the Service selects. Remember this sentence for the CKAD exam:

> Services route to Pods through labels, not to Deployments directly.

## Learning objectives

After this module you can:

- Explain how a Service selector chooses its backend pods.
- Explain how a Deployment's labels, its pod template labels and a Service's endpoints fit together.
- Update the image of one Deployment with `kubectl set image`.
- Switch traffic by patching a Service selector.
- Prove where traffic goes by reading the Service's endpoints.

## Before you start

This module assumes you can run `kubectl` commands and read their output. You should know that a pod is one running copy of an app (a spaceship), and that a Deployment keeps a set number of pods running (the fleet order).

The graded lab builds its own small Kubernetes cluster with the `astrona` tool, so you need the `astrona` tool and a container engine (Docker or Podman) on your computer.

## The parts of this module

Read the parts in this order. Each one takes about 5 to 10 minutes.

| Part | What you learn |
| --- | --- |
| [How A Service Finds Its Pods](./course-01-how-a-service-finds-its-pods.md) | Labels, selectors and endpoints, and why a selector that is too broad sends traffic to both versions |
| [Update One Version And Switch The Traffic](./course-02-update-one-version-and-switch-traffic.md) | Changing one Deployment's image, patching a Service selector, proving the switch, then your graded mission |
| [Wrap-Up: Mission Debrief](./course-03-wrap-up.md) | What you learned, your mission, exam habits, practice ideas and cleaning up |

## Why this matters

The CKAD exam often asks you to "point a Service at" one set of pods. If you think a Service points at a Deployment by name, you will edit the wrong thing. Once you see that the Service only reads pod labels, every one of these tasks becomes a quick check of labels and one selector change.
