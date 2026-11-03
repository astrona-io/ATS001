---
draft: true
exam_objectives:
- Understand Deployments and how to perform rolling updates
---
# Roll Back To A Named Revision

Return Deployment `probe` to the version-one Pod template and record why in the change-cause annotation. The task and reference solution use a separate pinned kind cluster. The grader checks declared fields and bounded live evidence. Python 3 is required on the grading host.

Run `testing/smoke.sh` with the lab's private kubeconfig to prove that the starting state fails and the reference repair passes. Runtime verification is pending: this lab has not been started yet, and static checks are not runtime evidence.
