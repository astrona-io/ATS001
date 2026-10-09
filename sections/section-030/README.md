# Section 030: Canary Deployments With Kustomize

A canary deployment sends a small share of traffic to a new version first. In Kubernetes you can shape that share with pod counts, and Kustomize lets you keep those counts per environment without copying your files. Astronaut, think of a small scout group of new ships flying in the fleet before everyone switches.

## Modules

| Module | What you learn | Graded mission |
| --- | --- | --- |
| [Shape A Canary With Kustomize Overlays](./module-01/course.md) | Traffic share by pod count, Kustomize bases and overlays, and rendering before you apply | None yet |

## What you need

A practice Kubernetes cluster (for example one made with `kind create cluster`) and `kubectl`. Kustomize is built into `kubectl`, so you need nothing else.
