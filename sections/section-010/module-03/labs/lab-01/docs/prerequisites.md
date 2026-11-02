---
draft: true
exam_objectives:
- Use Kubernetes primitives to implement common deployment strategies (e.g. blue/green
  or canary)
---
# Prerequisites

Use a host shell with astrona, kubectl and Python 3. 

Use a host shell with this lab's private kubeconfig. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool. This environment is separate from the ungraded playground.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-001-lab-010-03-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-001-lab-010-03-01" || exit 1
```

Keep this connection selected throughout the task. Every script supplied by the lab refuses a different context.
