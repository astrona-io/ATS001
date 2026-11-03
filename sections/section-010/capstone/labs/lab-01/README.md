---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green or canary)
---
# Blue-Green And Canary Release Capstone

Release two applications with two strategies: switch `probe` to a prepared green version and add a one-replica canary to `relay`. The task and reference solution use a separate pinned kind cluster. The grader checks declared fields and bounded live evidence. Python 3 is required on the grading host.

Run `testing/smoke.sh` with the lab's private kubeconfig to prove that the starting state fails and the reference repair passes. Runtime verification is pending: this lab has not been started yet, and static checks are not runtime evidence.
