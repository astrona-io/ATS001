# Section 010: Blue-Green Deployments

Blue-green deployment keeps two versions of an app running at the same time and lets you move all traffic from one to the other in a single step. Astronaut, picture two whole fleets in flight and one beacon: you decide which fleet answers it.

## Modules

This section has one module. It teaches how a Service picks its pods by label, and how changing that choice switches the traffic.

| Module | What you learn | Graded mission |
| --- | --- | --- |
| [Switch Traffic Between Two Versions](./module-01/course.md) | Labels, Service selectors and endpoints; updating one version's image; switching a Service from both versions to one | [Blue-Green Service Switch Lab](./module-01/labs/lab-01/README.md) |

## What you need

A terminal with `kubectl`, and the `astrona` tool to start the graded lab. The lab builds its own small Kubernetes cluster.
